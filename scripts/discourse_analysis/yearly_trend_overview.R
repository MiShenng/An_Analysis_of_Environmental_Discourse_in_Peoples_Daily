  # 加载必要的包
  library(readxl)
  library(dplyr)
  library(ggplot2)
  library(showtext)
  showtext.auto()
  
  # ---------- 系统级配置（保持原始设置） ----------
  Sys.setlocale("LC_CTYPE", "zh_CN.UTF-8")  # 中文环境
  font_add(
    family = "mac_hei", 
    regular = "/System/Library/Fonts/Supplemental/Songti.ttc"
  )
  showtext_auto(enable = TRUE)
  
  # ------------------------- 数据处理 -------------------------
  # 情感倾向年度分析（保持分组逻辑）
  sentiment_year <- data %>%
    group_by(年份, `报道情感倾向`) %>% 
    summarise(n = n(), .groups = "drop_last") %>%  # 保持分组结构
    mutate(percentage = n / sum(n) * 100) %>% 
    ungroup() %>% 
    filter(!is.na(`报道情感倾向`))  # 过滤缺失值
 
  
  
  
  # ------------------------- 形状编码可视化方案 -------------------------
  ggplot(sentiment_year, 
         aes(x = 年份, 
             y = percentage,
             shape = `报道情感倾向`,  # 形状映射情感倾向
             group = `报道情感倾向`)) +
    # 视觉元素系统
    geom_line(color = "gray50", linewidth = 0.8, alpha = 0.8) +  # 统一线条颜色
    geom_point(aes(fill = `报道情感倾向`), 
               size = 3, stroke = 0.8, color = "gray30") +  # 轮廓色统一
    
    # 坐标轴智能配置
    scale_x_continuous(
      breaks = seq(min(sentiment_year$年份), max(sentiment_year$年份), 3),
      labels = ~paste0(., "")
    ) +
    
    # 形状-色彩映射系统
    scale_shape_manual(values = c(21, 22, 24)) +  # 空心圆形/方形/三角形
    scale_fill_grey(start = 0.2, end = 0.8) +     # 灰度填充色
    
    # 专业级标签系统
    labs(x = "分析年份", 
         y = "分布比例 (%)",
         title = "媒体情感倾向形态编码历时趋势分析") +
    
    # 学术图表主题
    theme_classic(base_family = "mac_hei") +
    theme(
      axis.text.x = element_text(angle = 30, hjust = 0.8, size = 11),
      legend.position = "bottom",
      legend.key.size = unit(1.2, "lines"),
      panel.grid.major.y = element_line(colour = "gray93")
    ) +
    
    # 图例系统优化
    guides(
      shape = guide_legend(title = "情感倾向",
                           override.aes = list(size = 4)),
      fill = guide_legend(title = "情感倾向")
    )
  
  
  
  
  
  # ---------------------报道情感倾向——————————————————————————————
  # ====================== 通用分析框架 ========================
  # 定义核心分析函数
  analyze_temporal <- function(data, var_name, top_n = 5) {
    # 数据处理
    df <- data %>%
      mutate(年份 = as.numeric(年份)) %>%
      group_by(年份, !!sym(var_name)) %>%
      summarise(n = n(), .groups = "drop_last") %>%
      mutate(percentage = n / sum(n) * 100) %>%
      ungroup() %>%
      filter(!is.na(!!sym(var_name))) %>%
      group_by(年份) %>%
      slice_max(order_by = percentage, n = top_n, with_ties = FALSE) %>%
      ungroup()
    
    # 自动形状分配系统
    shape_pool <- c(21, 22, 23, 24, 25)
    shapes <- setNames(shape_pool[1:n_distinct(df[[var_name]])], unique(df[[var_name]]))
    
    # 可视化引擎
    ggplot(df, aes(x = 年份, y = percentage,
                   shape = !!sym(var_name),
                   group = !!sym(var_name))) +
      geom_line(color = "gray60", linewidth = 0.7, alpha = 0.8) +
      geom_point(aes(fill = !!sym(var_name)), 
                 size = 3.5, stroke = 0.8, color = "gray30") +
      scale_x_continuous(
        breaks = seq(floor(min(df$年份)/5)*5, ceiling(max(df$年份)/5)*5, 5),
        labels = ~paste0(., "年")
      ) +
      scale_shape_manual(values = shapes) +
      scale_fill_grey(start = 0.2, end = 0.8) +
      labs(x = "分析年份", y = "比例 (%)", title = paste0(var_name, "历时趋势分析")) +
      theme_classic(base_family = "mac_hei") +
      theme(
        axis.text.x = element_text(angle = 40, hjust = 1, size = 10),
        legend.position = "right",
        legend.key.height = unit(1.5, "lines")
      )
  }
  
  # ====================== 变量分析执行 ========================
  # 定义分析变量列表
  analysis_vars <- c(
    "报道体裁", "报道主要信源", "报道情感倾向",
    "报道议题", "报道议题二级分类", 
    "叙述方式", "关涉主体", "关涉主体二级分类"
  )
  
  # 批量生成图表（示例：报道体裁）
  (plot_report_type <- analyze_temporal(data, "报道体裁", top_n = 5))
  
  # 其他变量生成方式相同，替换变量名即可
  # (plot_source <- analyze_temporal(data, "报道主要信源"))
  # (plot_topic <- analyze_temporal(data, "报道议题"))
  
  # ====================== 高级定制示例 ========================
  # 专题案例：报道议题深度分析
  topic_analysis <- data %>%
    filter(!is.na(报道体裁)) %>%
    group_by(年份, 报道体裁) %>%
    summarise(n = n(), .groups = "drop_last") %>%
    mutate(percentage = n / sum(n) * 100) %>%
    ungroup() %>%
    group_by(年份) %>%
    slice_max(percentage, n = 6) %>%
    ungroup()
  
  ggplot(topic_analysis, aes(x = 年份, y = percentage, 
                             color = 报道体裁, linetype = 报道体裁)) +
    geom_line(linewidth = 1) +
    geom_point(size = 3, shape = 21, fill = "white", stroke = 1) +
    scale_color_manual(values = rep("black", n_distinct(topic_analysis$报道体裁))) +
    scale_linetype_manual(values = 1:5) +
    labs(title = "核心议题趋势对比") +
    theme_classic(base_family = "mac_hei") +
    theme(legend.key.width = unit(2, "cm"))
  
  
