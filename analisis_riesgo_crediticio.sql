1️⃣ Exploración básica de la cartera
/* =========================================================
   1. Distribución de clientes por género
   Objetivo:
   Analizar la composición demográfica de la cartera.
========================================================= */
SELECT 
    CODE_GENDER,
    COUNT(*) AS total_clientes,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS porcentaje
FROM application_train
GROUP BY CODE_GENDER;

Comencé con una exploración demográfica para entender la composición de la base de clientes.

/* =========================================================
   2. Ingreso promedio de los clientes
   Objetivo:
   Evaluar la capacidad económica general de la cartera.
========================================================= */
SELECT 
    ROUND(AVG(AMT_INCOME_TOTAL), 2) AS ingreso_promedio,
    MIN(AMT_INCOME_TOTAL) AS ingreso_minimo,
    MAX(AMT_INCOME_TOTAL) AS ingreso_maximo
FROM application_train;

Analicé el rango de ingresos para justificar una segmentación posterior.

2️⃣ Exposición crediticia
/* =========================================================
   3. Clientes con mayor nivel de crédito otorgado
   Objetivo:
   Identificar concentración de riesgo crediticio.
========================================================= */
SELECT 
    SK_ID_CURR,
    AMT_CREDIT
FROM application_train
ORDER BY AMT_CREDIT DESC
LIMIT 10;

Esto permite detectar clientes con mayor impacto potencial en caso de default.

3️⃣ Análisis del buró de crédito
/* =========================================================
   4. Promedio de crédito y deuda por tipo de crédito
   Objetivo:
   Evaluar el endeudamiento relativo por producto.
========================================================= */
SELECT 
    CREDIT_TYPE,
    ROUND(AVG(AMT_CREDIT_SUM), 2) AS credito_promedio,
    ROUND(AVG(AMT_CREDIT_SUM_DEBT), 2) AS deuda_promedio,
    ROUND(
        AVG(AMT_CREDIT_SUM_DEBT) / NULLIF(AVG(AMT_CREDIT_SUM), 0),
        3
    ) AS ratio_deuda_credito
FROM bureau
GROUP BY CREDIT_TYPE
ORDER BY ratio_deuda_credito DESC;


Comparé deuda vs crédito por tipo de producto para detectar los más riesgosos.

4️⃣ Bancarización y uso de tarjetas
/* =========================================================
   5. Total de tarjetas por cliente
   Objetivo:
   Medir el nivel de bancarización.
========================================================= */
SELECT 
    SK_ID_CURR,
    COUNT(*) AS total_tarjetas
FROM credit_card_balance
GROUP BY SK_ID_CURR;


La cantidad de tarjetas sirve como proxy de bancarización.

/* =========================================================
   6. Clientes con historial crediticio y tarjetas
   Objetivo:
   Identificar clientes con múltiples productos financieros.
========================================================= */
SELECT 
    a.SK_ID_CURR,
    COUNT(DISTINCT b.SK_ID_BUREAU) AS cantidad_creditos,
    COUNT(DISTINCT c.SK_ID_PREV) AS cantidad_tarjetas
FROM application_train a
LEFT JOIN bureau b ON a.SK_ID_CURR = b.SK_ID_CURR
LEFT JOIN credit_card_balance c ON a.SK_ID_CURR = c.SK_ID_CURR
GROUP BY a.SK_ID_CURR;


Integré distintas fuentes para tener una visión completa del cliente.

5️⃣ Riesgo financiero (CLAVE 🔥)
/* =========================================================
   7. Ratio de endeudamiento por cliente
   Objetivo:
   Medir la presión financiera individual.
========================================================= */
WITH deuda AS (
    SELECT 
        SK_ID_CURR,
        SUM(AMT_CREDIT_SUM_DEBT) AS total_deuda
    FROM bureau
    GROUP BY SK_ID_CURR
),
credito AS (
    SELECT 
        SK_ID_CURR,
        SUM(AMT_CREDIT_SUM) AS total_credito
    FROM bureau
    GROUP BY SK_ID_CURR
)
SELECT 
    a.SK_ID_CURR,
    c.total_credito,
    d.total_deuda,
    ROUND(d.total_deuda / NULLIF(c.total_credito, 0), 3) AS ratio_endeudamiento
FROM application_train a
JOIN deuda d ON a.SK_ID_CURR = d.SK_ID_CURR
JOIN credito c ON a.SK_ID_CURR = c.SK_ID_CURR;


Este ratio es clave para evaluar riesgo financiero individual.

6️⃣ Segmentación por ingresos
/* =========================================================
   8. Segmentación de clientes por nivel de ingreso
   Objetivo:
   Analizar riesgo promedio por capacidad económica.
========================================================= */
SELECT 
    CASE 
        WHEN AMT_INCOME_TOTAL < 80000 THEN 'Ingreso Bajo'
        WHEN AMT_INCOME_TOTAL BETWEEN 80000 AND 150000 THEN 'Ingreso Medio'
        ELSE 'Ingreso Alto'
    END AS segmento_ingreso,
    COUNT(*) AS clientes,
    ROUND(AVG(TARGET), 3) AS tasa_default
FROM application_train
GROUP BY segmento_ingreso;


Esto conecta directamente SQL con el dashboard en Power BI.

7️⃣ Clientes con mayor riesgo
/* =========================================================
   9. Clientes con mayor riesgo y alto endeudamiento
   Objetivo:
   Identificar perfiles críticos.
========================================================= */
SELECT 
    a.SK_ID_CURR,
    a.AMT_INCOME_TOTAL,
    b.CREDIT_TYPE,
    b.AMT_CREDIT_SUM_DEBT,
    b.AMT_CREDIT_SUM
FROM application_train a
JOIN bureau b ON a.SK_ID_CURR = b.SK_ID_CURR
WHERE a.TARGET = 1
ORDER BY b.AMT_CREDIT_SUM_DEBT DESC
LIMIT 20;

8️⃣ Ranking por deuda (nivel intermedio-alto)
/* =========================================================
   10. Ranking de clientes por deuda total
   Objetivo:
   Priorizar monitoreo de riesgo.
========================================================= */
SELECT 
    SK_ID_CURR,
    SUM(AMT_CREDIT_SUM_DEBT) AS deuda_total,
    RANK() OVER (ORDER BY SUM(AMT_CREDIT_SUM_DEBT) DESC) AS ranking_deuda
FROM bureau
GROUP BY SK_ID_CURR;


Utilicé window functions para priorizar clientes según nivel de deuda.

9️⃣ Pago vs límite de tarjeta
/* =========================================================
   11. Relación entre pagos y límite de crédito
   Objetivo:
   Evaluar comportamiento de pago.
========================================================= */
SELECT 
    SK_ID_CURR,
    ROUND(AVG(AMT_PAYMENT_TOTAL), 2) AS pago_promedio,
    ROUND(AVG(AMT_CREDIT_LIMIT_ACTUAL), 2) AS limite_promedio
FROM credit_card_balance
GROUP BY SK_ID_CURR;

Comparé pagos y límites como indicador de uso responsable del crédito.