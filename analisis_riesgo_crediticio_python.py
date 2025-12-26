# -*- coding: utf-8 -*-
"""
Proyecto: Análisis de Riesgo Crediticio
Autor: Karolina Romero
Descripción:
- Agrega información de buró y tarjetas
- Construye variables financieras a nivel cliente
- Genera dataset final para Power BI
"""


import pandas as pd

app = pd.read_csv(r"C:\ruta_de_archivo.csv")
bureau = pd.read_csv(r"C:\ruta_de_archivo.csv")
cc = pd.read_csv("C:\ruta_de_archivo.csv")

print(app.shape)
print(bureau.shape)
print(cc.shape)

bureau_agg = bureau.groupby("SK_ID_CURR").agg(
    total_bureau_credit=("AMT_CREDIT_SUM", "sum"),
    total_bureau_debt=("AMT_CREDIT_SUM_DEBT", "sum"),
    n_bureau_records=("SK_ID_BUREAU", "count")
).reset_index()

print(bureau_agg.shape)

cc_agg = cc.groupby("SK_ID_CURR").agg(
    avg_cc_balance=("AMT_BALANCE", "mean"),
    avg_cc_limit=("AMT_CREDIT_LIMIT_ACTUAL", "mean"),
    total_cc_payments=("AMT_PAYMENT_TOTAL", "sum"),
    n_cc_records=("SK_ID_PREV", "count")
).reset_index()

print(cc_agg.shape)

df = app.merge(bureau_agg, on="SK_ID_CURR", how="left")
df = df.merge(cc_agg, on="SK_ID_CURR", how="left")

print(df.shape)

cols_fill0 = [
    "total_bureau_credit", "total_bureau_debt", "n_bureau_records",
    "avg_cc_balance", "avg_cc_limit", "total_cc_payments", "n_cc_records"
]

df[cols_fill0] = df[cols_fill0].fillna(0)


df.to_csv("dataset_riesgo_final.csv", index=False)
print("Archivo final creado correctamente")

