加载必要的包
library(readxl)
library(dplyr)
library(ggplot2)
library(showtext)
showtext.auto()

#读取数据（请将文件路径替换为实际路径）
data <- read_excel("./on.xlsx")

#假设第一列为"年份"，其他变量如"报道体裁"
#按年份和报道体裁分组，计算每组频数及百分比
overview_report_type <- data %>%
  group_by(年份, 报道情感倾向) %>%
  summarise(n = n(), .groups = "drop") %>%
  group_by(年份) %>%
  mutate(percentage = n / sum(n) * 100)

#查看数据概览
print(overview_report_type)

#绘制随年份变化的折线图
#ggplot(overview_report_type, aes(x = 年份, y = percentage, color = 报道情感倾向, group = 报道情感倾向)) +
  geom_line() +
  geom_point() +
  labs(title = "年份与报道体裁变化概览",
       x = "年份",
       y = "百分比 (%)") +
  theme_minimal(base_size = 14)

#加载必要的包
library(readxl)
library(dplyr)
library(ggplot2)
library(showtext)
showtext.auto()

#---------- 系统级配置（保持原始设置） ----------
  Sys.setlocale("LC_CTYPE", "zh_CN.UTF-8") # 中文环境
font_add(
  family = "mac_hei",
  regular = "/System/Library/Fonts/Supplemental/Songti.ttc"
)
showtext_auto(enable = TRUE)

#------------------------- 数据处理 -------------------------
 # 情感倾向年度分析（保持分组逻辑）
sentiment_year <- data %>%
#  group_by(年份, 报道情感倾向) %>%
  summarise(n = n(), .groups = "drop_last") %>% # 保持分组结构
  mutate(percentage = n / sum(n) * 100) %>%
  ungroup() %>%
 # filter(!is.na(报道情感倾向)) # 过滤缺失值

#------------------------- 可视化引擎 -------------------------
  ggplot(sentiment_year,
         aes(x = factor(年份),
             y = percentage,
             color = 报道情感倾向,
             group = 报道情感倾向)) +
  # 核心几何对象
  geom_line(linewidth = 0.7, show.legend = FALSE) + # 控制线宽
  geom_point(size = 2, shape = 21, fill = "white", stroke = 0.8) + # 空心圆点
  # 数据标签系统
  geom_text(aes(label = sprintf("%.1f%%", percentage)),
            vjust = -1.2, # 垂直偏移量
            size = 4.5, # 字号匹配原图
            family = "mac_hei", # 字体统一
            check_overlap = TRUE) + # 防止标签重叠
  # 视觉映射系统
  scale_color_manual(values = c("gray30", "gray60", "gray90")) + # 灰阶配色
  # 标签系统
  labs(x = "报道年份",
       y = "百分比分布 (%)",
       title = "媒体报道情感倾向历时性分析") +
  # 主题引擎
  theme_classic(base_family = "mac_hei") + # 基准主题
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 10), # X轴标签倾斜
    axis.title = element_text(size = 12), # 坐标轴标题
    plot.title = element_text(hjust = 0.5, margin = margin(b = 15)), # 标题居中
    panel.grid.major.y = element_line(colour = "gray90", linewidth = 0.3) # 水平网格线
  )
