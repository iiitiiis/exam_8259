import csv
from collections import defaultdict
import sys

def process_csv(input_filename, output_filename):
    # 用 defaultdict 初始化字典，以城市、年份、罪名作为键
    crime_data = defaultdict(lambda: defaultdict(lambda: defaultdict(int)))

    # 读取原始数据文件
    with open(input_filename, 'r') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            city = row['City']
            year = row['Start_Date_Time'][:4]
            crime_name = row['Crime_Name1']

            # 统计受害者数量
            victims = int(row['Victims'])
            crime_data[city][year][crime_name] += victims

    # 将统计结果写入输出文件
    with open(output_filename, 'w', newline='') as csvfile:
        fieldnames = ['city', 'year', 'crime name', 'victims']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        
        # 写入 CSV 文件头
        writer.writeheader()

        # 遍历字典，并写入 CSV 文件
        for city, years in crime_data.items():
            for year, crimes in years.items():
                for crime_name, victims in crimes.items():
                    writer.writerow({'city': city, 'year': year, 'crime name': crime_name, 'victims': victims})

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python process_data.py <input_filename>")
        sys.exit(1)

    input_filename = sys.argv[1]
    output_filename = "test3/test3_output.csv"

    process_csv(input_filename, output_filename)
    print(f"Processing complete. Output saved to {output_filename}")
