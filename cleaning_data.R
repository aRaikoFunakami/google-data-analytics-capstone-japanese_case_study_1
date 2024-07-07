install.packages("tidyverse")
install.packages("lubridate")

library(tidyverse)
library(lubridate)

# Download from https://divvy-tripdata.s3.amazonaws.com/index.html
# License:https://divvybikes.com/data-license-agreement 
csv_directory <- "/Users/raiko.funakami/Downloads/Syclistic_Trip_Data/CSV_Files"
csv_files <- list.files(csv_directory, pattern = "*.csv", full.names = TRUE)

# すべてのCSVファイルを読み込み、1つのデータフレームに結合
all_data <- csv_files %>%
  map_df(~ read_csv(.))

# データの確認
str(all_data)

print("Data types of each column:")
select_all(all_data)

# 欠損値の確認
missing_values <- all_data %>%
  summarise_all(~ sum(is.na(.)))

print("Missing values in each column:")
print(missing_values)


# 重複行の確認
duplicate_rows <- all_data %>%
  duplicated() %>%
  sum()

print(paste("Number of duplicate rows:", duplicate_rows))

# 異常値の確認
#  ライド時間の計算
all_data <- all_data %>%
  mutate(ride_length = as.numeric(difftime(ended_at, started_at, units = "mins")))

# 異常値の確認
## マイナスのライド時間
## 極端に長い（24時間以上）
## 極端に短い（1分未満）
abnormal_ride_lengths <- all_data %>%
  filter(ride_length < 0)

extremely_long_rides <- all_data %>%
  filter(ride_length > 1440)  # 24時間 * 60分

extremely_short_rides <- all_data %>%
  filter(ride_length < 1)

print(paste("Number of rides with negative ride length:", nrow(abnormal_ride_lengths)))
print(paste("Number of extremely long rides:", nrow(extremely_long_rides)))
print(paste("Number of extremely short rides:", nrow(extremely_short_rides)))