import pandas as pd

from config import RAW_DATA_FILE


def preview_data():
    df = pd.read_csv(RAW_DATA_FILE)

    print("Data preview:")
    print(df.head())

    print("\nDataset shape:")
    print(df.shape)


if __name__ == "__main__":
    preview_data()