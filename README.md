# 📊 Análisis de Riesgo Crediticio

## 📌 Descripción del proyecto
Este proyecto tiene como objetivo realizar un **análisis integral de riesgo crediticio**, integrando información de solicitudes de crédito, buró crediticio y comportamiento en tarjetas, para identificar patrones asociados al incumplimiento de pago (*default*).

El enfoque combina **análisis en SQL**, **construcción de variables en Python** y **visualización en Power BI**, simulando un flujo de trabajo real en un entorno financiero.

## 🎯 Objetivo
- Analizar el riesgo crediticio de clientes utilizando múltiples fuentes de datos.
- Construir variables financieras relevantes a nivel cliente.
- Explorar la relación entre ingreso, endeudamiento y riesgo.
- Presentar los resultados en un dashboard claro y orientado a negocio.

## 🛠️ Herramientas utilizadas
- **MySQL**: análisis exploratorio, joins y agregaciones.
- **Python (pandas)**: integración de fuentes y feature engineering.
- **Power BI**: visualización, segmentación y análisis interactivo.
- **GitHub**: documentación y presentación del proyecto.

## 🗂️ Estructura del proyecto

riesgo-crediticio-analisis/
│
├── README.md
│
├── sql/
│ ├── 01_exploracion_basica.sql
│ ├── 02_join_clientes_bureau.sql
│ ├── 03_segmentacion_ingresos.sql
│ ├── 04_ranking_deuda.sql
│
├── python/
│ └── feature_engineering.py
│
├── data/
│ └── dataset_riesgo_final.csv
│
├── power_bi/
│ ├── dashboard_riesgo.pbix
│ └── dashboard_preview.png

## 🧮 Fuentes de datos
Se trabajó con tres datasets sintéticos que representan información realista del negocio:

- **application_train_sintetico**  
  Datos de la solicitud de crédito (ingreso, monto solicitado, target).

- **bureau_sintetico**  
  Historial crediticio del cliente (créditos previos y deuda).

- **credit_card_balance_sintetico**  
  Información de tarjetas de crédito (balances, límites y pagos).

---

## 🔍 Análisis en SQL
En SQL se realizaron:
- Análisis exploratorio inicial.
- Uniones entre clientes y buró crediticio.
- Cálculo de ratios de endeudamiento.
- Segmentación por nivel de ingresos.
- Rankings de clientes según deuda acumulada.

Las consultas se encuentran organizadas por temática en la carpeta `sql/`.

---

## 🐍 Procesamiento y feature engineering en Python
En Python se realizó:
- Agregación de información de buró y tarjetas a nivel cliente.
- Integración de las tres fuentes mediante *left joins*.
- Imputación de valores nulos.
- Construcción de variables financieras como:
  - Deuda total
  - Uso promedio de tarjetas
  - Cantidad de créditos y tarjetas
- Generación del dataset final para análisis y visualización.

El script completo se encuentra en `analisis_riesgo_crediticio_python`.

---

## 📊 Visualización en Power BI
El dashboard permite:
- Analizar el riesgo por segmentación de ingresos.
- Comparar indicadores financieros entre segmentos.
- Explorar métricas clave de endeudamiento y comportamiento crediticio.

📸 Vista previa del dashboard:

<img width="889" height="496" alt="image" src="https://github.com/user-attachments/assets/13aafed5-97a8-4be4-afad-567171b54f68" />

## 🧠 Conclusiones
- El nivel de ingreso por sí solo no explica completamente el riesgo crediticio.
- Los indicadores de endeudamiento y utilización de tarjetas tienen mayor relación con el default.
- El segmento de ingresos medios concentra una proporción relevante de clientes de alto riesgo.
- Integrar datos de buró y tarjetas mejora significativamente el análisis frente a usar solo datos de solicitud.

---

## 🚀 Próximos pasos
- Incorporar variables temporales de comportamiento.
- Desarrollar un modelo predictivo de riesgo crediticio.
- Profundizar la segmentación por tipo de producto financiero.

---

## 👩‍💻 Autora
**Karolina Romero**  
Proyecto realizado con fines educativos y de portfolio profesional.
