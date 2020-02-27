library(tidyverse)
library(readxl)

# 数据文件路径是相对工程目录，不是相对源码
p80_10 <- read_excel("report/data/p80-10.xlsx")

age_sep <- function(Age) {
  map_chr(Age, function(age) {
    if (age < 30) {
      "0-30"
    } else if (age < 60) {
      "30-60"
    } else {
      "60-100"
    }
  })
}

p80_10 %>%
  filter(Area == "Total", Sex == "Both Sexes") %>%
  mutate(age_group = age_sep(Age)) %>%
  group_by(Year, age_group) %>%
  summarise(popu = sum(Value)) %>%
  mutate(percent = popu / sum(popu) * 100) %>%
  pivot_wider(
    id_cols = c("Year"),
    names_from = "age_group",
    values_from = "percent"
  ) %>%
  knitr::kable(col.names = c("year", "0-30", "30-60", "60-100"))

p80_10 %>%
  filter(Area == "Total", Sex == "Both Sexes") %>%
  mutate(r1 = Value / 2,
         r2 = -Value / 2) %>%
  ggplot(aes(Age)) +
  geom_col(aes(y = r1), width = 1) +
  geom_col(aes(y = r2), width = 1) +
  theme_minimal() +
  theme(axis.text.x = element_text(colour = NA)) +
  coord_flip() +
  facet_grid(cols = vars(Year)) +
  labs(
    title = "年龄分布（1982-2010）",
    y = NULL,
    x = "年龄",
    caption = "数据来自联合国统计司"
  )

half_male_mark <- p80_10 %>%
  filter(Area != "Total", Sex != "Both Sexes", Age >= 0 &
           Age <= 100) %>%
  pivot_wider(names_from = Sex, values_from = Value) %>%
  filter(Male / Female <= 0.5) %>%
  group_by(Year, Area) %>%
  summarise(min_age = min(Age))


p80_10 %>%
  filter(Area != "Total", Sex != "Both Sexes", Age >= 0 &
           Age <= 100) %>%
  pivot_wider(names_from = Sex, values_from = Value) %>%
  ggplot(aes(Age, Male / Female, colour = Area)) +
  geom_line() +
  geom_text(
    data = half_male_mark,
    mapping = aes(min_age, 0.5, label = min_age),
    position = position_jitter(height = .2)
  ) +
  theme_minimal() +
  facet_grid(vars(Year)) +
  scale_color_discrete(labels = c("农村", "城市")) +
  labs(
    title = "农村城市男女比例（1982-2010）",
    x = "年龄",
    y = "男/女",
    colour = "地域",
    caption = "数据来自联合国统计司"
  )

p80_10 %>%
  filter(Area != "Total", Sex == "Both Sexes") %>%
  group_by(Year, Area) %>%
  summarise(popu = sum(Value)) %>%
  ggplot(aes(Year, popu, colour = Area)) +
  geom_line() +
  geom_point() +
  theme_minimal() +
  scale_y_continuous(labels = scales::unit_format(unit = "亿", scale = .00000001)) +
  scale_color_discrete(labels = c("农村", "城市")) +
  scale_x_continuous(breaks = c(1982, 1987, 1990, 2000, 2010)) +
  labs(
    title = "农村城市人口变化（1982-2010）",
    x = "时间",
    y = "人口",
    colour = "地域",
    caption = "数据来自联合国统计司"
  )
