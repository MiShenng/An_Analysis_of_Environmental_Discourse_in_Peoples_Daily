#
# 加载必要的包
# 加载必要的包
library(ggplot2)
library(dplyr)
library(readxl)

# 读取Excel数据（假设文件名为"your_data.xlsx"）
data <- read_excel("try.xlsx")  # 这里替换成你实际的文件路径

# 查看数据的前几行，确认数据格式和列名
head(data)

# 假设第四列名为 V4，你可以查看数据的列名，并相应调整
colnames(data)

# 计算第四列各变量的占比
variable_proportions <- data %>%
  count(报道体裁) %>%  # 计算第四列每个不同值的频数
  mutate(percentage = n / sum(n) * 100)  # 计算占比

# 查看结果
print(variable_proportions)

# 绘制条形图
ggplot(variable_proportions, aes(x = V4, y = percentage, fill = V4)) +
  geom_bar(stat = "identity") +
  labs(title = "第四列各变量占比", x = "变量", y = "占比 (%)") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # 旋转x轴标签以便更好显示
