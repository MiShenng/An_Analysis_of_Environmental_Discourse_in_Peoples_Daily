# ---------------------------
# 加载所需的包
# ---------------------------
library(readxl)
library(dplyr)
library(jsonlite)
library(writexl)
library(httr)
library(rlang)         # 用于 %||% 运算符
library(future.apply)  # 并行计算包
library(progressr)     # 进度条包

# 设置 progressr 处理器（使用控制台进度条）
handlers("progress")

# ---------------------------
# 设置文件路径
# ---------------------------
file_path <- "./all.xlsx"
final_output <- "./all_1.xlsx"

# ---------------------------
# 读取数据并初始化列（新增“报道议题二级分类”和“关涉主体二级分类”）
# ---------------------------
data <- read_excel(file_path) %>%
  mutate(报道体裁 = NA_character_,
         报道主要信源 = NA_character_,
         报道次要信源 = NA_character_,
         报道情感倾向 = NA_character_,
         报道议题 = NA_character_,
         报道议题二级分类 = NA_character_,
         叙述方式 = NA_character_,
         关涉主体 = NA_character_,
         关涉主体二级分类 = NA_character_,
         是否环境新闻报道 = NA_character_)

# ---------------------------
# API配置
# ---------------------------
api_endpoint <- "https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions"
api_key <- Sys.getenv("DASHSCOPE_API_KEY")
model <- "deepseek-v3"

if (!nzchar(api_key)) {
  stop("Please set DASHSCOPE_API_KEY before running this script.")
}

# ---------------------------
# 改进的API调用函数（规范请求格式）
# ---------------------------
call_deepseek_api <- function(prompt) {
  body <- list(
    model = model,
    messages = list(list(role = "user", content = prompt)),
    temperature = 0.2,
    top_p = 0.8,
    max_tokens = 4000,
    response_format = list(type = "json_object")
  )
  
  response <- tryCatch({
    POST(
      url = api_endpoint,
      add_headers(
        `Authorization` = paste("Bearer", api_key),
        `Content-Type` = "application/json"
      ),
      body = toJSON(body, auto_unbox = TRUE),
      encode = "json"
    )
  }, error = function(e) {
    message("API调用失败：", e$message)
    return(NULL)
  })
  
  # 错误处理
  if (is.null(response)) return("")
  if (status_code(response) != 200) {
    message("API错误[", status_code(response), "]: ", content(response, "text"))
    return("")
  }
  
  # 解析响应
  result <- content(response, "parsed")
  result$choices[[1]]$message$content
}

# ---------------------------
# 强化提示词模板（更新类目规则，要求返回9个字段，顺序调整且二级分类默认“其他”）
# ---------------------------
generate_prompt <- function(text) {
  sprintf(
    '你是一个环境传播内容分析编码员，我需要你对我筛选出的《人民日报》文本进行编码，请根据以下规则处理文本：
<规则>
1. 报道体裁（单选）：消息、通讯、深度报道、评论、图片、科普与研究性文章、其他
2. 报道主要信源（单选）：政府、企业、环保组织、媒体自采自评、学术界、普通公众、涉及国际。若文本中出现多个信源，请仅返回首要和次要两个信源。
3. 报道次要信源 （单选且不与主要信源重复） ：政府、企业、环保组织、媒体自采自评、学术界、普通公众、涉及国际。
3. 报道情感倾向（单选）：积极、中立、消极
4. 报道议题（单选）：一级分类包括常规性议题、周期性议题、突发性议题
5. 报道议题二级分类（单选）：二级分类包括水污染防治、大气污染防治、土壤污染防治、核与辐射污染防治、重金属污染防治、固体废物处置处理、化学品污染防治、环境政策法规、生态区或生物多样性、产业优化或能源结构调整、生态科技创新、全球环境治理或国际合作、环境宣传教育、公众参与、公共卫生
6. 叙述方式（单选）：硬新闻、软新闻
7. 关涉主体（单选）：一级分类包括政府、企业、普通公众、学界、环保组织、国际主体
8. 关涉主体二级分类（单选）：根据关涉主体的一级分类进行二级划分：
   - 针对“政府”主题，其行为表现可分为：承认不足、完善政策法规、监管机制建构、污染防治、生态修复、环境信息公开、引导公众参与、科技创新、国际协作、问责处理、财政投入
   - 针对“企业”主题，其行为表现可分为：节能减排、生态修复、违法排放、技术创新、遮掩问题、传统产能依赖、环保投入不足、管理机制缺陷、服务社会
   - 针对“普通公众”主题，其行为表现可分为：环保监督、模范示例、权益维护、知识学习、其他
   - 针对“学界”主题，其行为表现可分为：技术创新、环境监督、科普大众、辅助治理
   - 针对“环保组织”主题，其行为表现可分为：建言献策、呼吁倡导、科普教育、组织活动、活动受阻
   - 针对“国际主体”主题，其行为表现可分为：环境监督、跨国合作、科普宣传、公众参与、其他
9. 是否环境新闻报道 （单选）：是，不是，存疑

</规则>

<要求>
- 必须返回严格的JSON格式
- JSON必须包含且只以下九个键，且顺序为：报道体裁, 报道信源, 报道情感倾向, 报道议题, 报道议题二级分类, 叙述方式, 关涉主体, 关涉主体二级分类，是否环境新闻报道
- 对于报道议题和关涉主体，请分别返回一级分类和对应的二级分类；若没有明确细分二级分类或关涉主体为“其他”，则相应二级分类返回“其他”
- 空值保持空字符串
- 关涉主体是指环境报道中向受众表达新闻事实的行为主体
- 不要返回任何额外内容
- 严格按照规则输出，不要虚构类目或输出不在规则中的类目
</要求>

请按照以上示例格式处理：%s', text)
}

# ---------------------------
# 定义处理单行数据的函数
# ---------------------------
process_row <- function(i) {
  text_content <- data$文本内容[i]
  prompt <- generate_prompt(text_content)
  
  response_text <- ""
  for (retry in 1:3) {
    response_text <- call_deepseek_api(prompt)
    if (nzchar(response_text)) break
    if (retry < 3) {
      message("第", i, "行第", retry, "次重试...")
      Sys.sleep(1.5)
    }
  }
  
  res_list <- tryCatch({
    res <- fromJSON(response_text)
    required_fields <- c("报道体裁", "报道信源", "报道情感倾向", "报道议题",
                         "报道议题二级分类", "叙述方式", "关涉主体", "关涉主体二级分类", "是否环境新闻报道")
    stopifnot(all(required_fields %in% names(res)))
    
    # 替换中文逗号为英文逗号
    res$`报道信源` <- gsub("，", ",", res$`报道信源`)
    res$`叙述方式` <- gsub("，", ",", res$`叙述方式`)
    
    # 如果报道议题二级分类为空，则返回“其他”
    if (trimws(res$`报道议题二级分类`) == "") {
      res$`报道议题二级分类` <- "其他"
    }
    # 如果关涉主体为“其他”或关涉主体二级分类为空，则返回“其他”
    if (trimws(res$`关涉主体二级分类`) == "" || res$`关涉主体` == "其他") {
      res$`关涉主体二级分类` <- "其他"
    }
    res
  }, error = function(e) {
    message("解析失败 (行", i, "): ", e$message)
    message("原始响应：", response_text)
    NULL
  })
  return(res_list)
}

# ---------------------------
# 并行处理：设置并行方案
# ---------------------------
plan(multisession)  # Windows 或 macOS 下使用；Linux 可考虑 plan(multicore)

# ---------------------------
# 使用 future_lapply 同时发起多个 API 请求，并添加进度条
# ---------------------------
results <- with_progress({
  p <- progressor(along = seq_len(nrow(data)))
  future_lapply(seq_len(nrow(data)), function(i) {
    start_time <- Sys.time()
    res <- process_row(i)
    time_taken <- as.numeric(difftime(Sys.time(), start_time, units = "secs"))
    p(message = sprintf("已处理第 %d 行 | 用时: %.2f秒 | 剩余时间估算: %.2f秒", 
                        i, time_taken, (nrow(data) - i) * time_taken))
    res
  })
})

# ---------------------------
# 将返回结果填充到 data 数据框中，并每处理200行保存一次
# ---------------------------
for (i in seq_len(nrow(data))) {
  res_list <- results[[i]]
  if (!is.null(res_list)) {
    data[i, "报道体裁"] <- res_list$`报道体裁` %||% NA
    data[i, "报道信源"] <- res_list$`报道信源` %||% NA
    data[i, "报道情感倾向"] <- res_list$`报道情感倾向` %||% NA
    data[i, "报道议题"] <- res_list$`报道议题` %||% NA
    data[i, "报道议题二级分类"] <- res_list$`报道议题二级分类` %||% NA
    data[i, "叙述方式"] <- res_list$`叙述方式` %||% NA
    data[i, "关涉主体"] <- res_list$`关涉主体` %||% NA
    data[i, "关涉主体二级分类"] <- res_list$`关涉主体二级分类` %||% NA
    data[i, "是否环境新闻报道"] <- res_list$`是否环境新闻报道` %||% NA
  }
  
  # 每处理200行或最后一行时保存一次
  if (i %% 200 == 0 || i == nrow(data)) {
    write_xlsx(data[1:i, ], final_output)
    message("已保存至第", i, "行")
  }
}

message("处理完成！结果已保存至：", final_output)
