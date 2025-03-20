CREATE OR REPLACE TABLE `master-engine-450912-g8.pbi_kf.analyze_table` AS
SELECT 
    -- Data transaksi
    t.transaction_id,
    t.date,
    t.branch_id,
    
    -- Data cabang
    c.branch_name,
    c.kota,
    c.provinsi,
    c.rating AS rating_cabang,

    -- Data pelanggan
    t.customer_name,

    -- Data produk
    t.product_id,
    p.product_name,
    p.product_category,
    p.price AS actual_price,
    t.discount_percentage,

    -- Menghitung nett_sales (harga setelah diskon)
    p.price * (1 - t.discount_percentage) AS nett_sales,

    -- Menentukan persentase gross laba berdasarkan harga produk
    CASE 
        WHEN p.price > 500000 THEN 0.3
        WHEN p.price > 300000 THEN 0.25
        WHEN p.price > 100000 THEN 0.2
        WHEN p.price > 50000 THEN 0.15
        ELSE 0.1
    END AS persentase_gross_laba,

    -- Menghitung nett_profit (keuntungan setelah diskon)
    (p.price * (1 - t.discount_percentage)) * 
    CASE 
        WHEN p.price > 500000 THEN 0.3
        WHEN p.price > 300000 THEN 0.25
        WHEN p.price > 100000 THEN 0.2
        WHEN p.price > 50000 THEN 0.15
        ELSE 0.1
    END AS nett_profit,

    -- Rating transaksi dari pelanggan
    t.rating AS rating_transaksi

FROM `master-engine-450912-g8.pbi_kf.kf_final_transaction` AS t
LEFT JOIN `master-engine-450912-g8.pbi_kf.kf_kantor_cabang` AS c 
    ON t.branch_id = c.branch_id
LEFT JOIN `master-engine-450912-g8.pbi_kf.kf_product` AS p 
    ON t.product_id = p.product_id;
