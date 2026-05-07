SET search_path TO hans;
-------------------------------------------------
-- 1. Country
-------------------------------------------------
INSERT INTO countries (key, name) VALUES
('MX', 'Mexico'),
('US', 'United States');

-------------------------------------------------
-- 3. States (MX & US)
-------------------------------------------------
INSERT INTO states (key, name, country_id) VALUES
-- MX
('AGU', 'Aguascalientes', (SELECT country_id FROM countries WHERE key = 'MX')),
('BCN', 'Baja California', (SELECT country_id FROM countries WHERE key = 'MX')),
('BCS', 'Baja California Sur', (SELECT country_id FROM countries WHERE key = 'MX')),
('CAM', 'Campeche', (SELECT country_id FROM countries WHERE key = 'MX')),
('CHP', 'Chiapas', (SELECT country_id FROM countries WHERE key = 'MX')),
('CHH', 'Chihuahua', (SELECT country_id FROM countries WHERE key = 'MX')),
('COA', 'Coahuila', (SELECT country_id FROM countries WHERE key = 'MX')),
('COL', 'Colima', (SELECT country_id FROM countries WHERE key = 'MX')),
('DUR', 'Durango', (SELECT country_id FROM countries WHERE key = 'MX')),
('GUA', 'Guanajuato', (SELECT country_id FROM countries WHERE key = 'MX')),
('GRO', 'Guerrero', (SELECT country_id FROM countries WHERE key = 'MX')),
('HID', 'Hidalgo', (SELECT country_id FROM countries WHERE key = 'MX')),
('JAL', 'Jalisco', (SELECT country_id FROM countries WHERE key = 'MX')),
('MEX', 'Estado de México', (SELECT country_id FROM countries WHERE key = 'MX')),
('MIC', 'Michoacán', (SELECT country_id FROM countries WHERE key = 'MX')),
('MOR', 'Morelos', (SELECT country_id FROM countries WHERE key = 'MX')),
('NAY', 'Nayarit', (SELECT country_id FROM countries WHERE key = 'MX')),
('NLE', 'Nuevo León', (SELECT country_id FROM countries WHERE key = 'MX')),
('OAX', 'Oaxaca', (SELECT country_id FROM countries WHERE key = 'MX')),
('PUE', 'Puebla', (SELECT country_id FROM countries WHERE key = 'MX')),
('QUE', 'Querétaro', (SELECT country_id FROM countries WHERE key = 'MX')),
('ROO', 'Quintana Roo', (SELECT country_id FROM countries WHERE key = 'MX')),
('SLP', 'San Luis Potosí', (SELECT country_id FROM countries WHERE key = 'MX')),
('SIN', 'Sinaloa', (SELECT country_id FROM countries WHERE key = 'MX')),
('SON', 'Sonora', (SELECT country_id FROM countries WHERE key = 'MX')),
('TAB', 'Tabasco', (SELECT country_id FROM countries WHERE key = 'MX')),
('TAM', 'Tamaulipas', (SELECT country_id FROM countries WHERE key = 'MX')),
('TLA', 'Tlaxcala', (SELECT country_id FROM countries WHERE key = 'MX')),
('VER', 'Veracruz', (SELECT country_id FROM countries WHERE key = 'MX')),
('YUC', 'Yucatán', (SELECT country_id FROM countries WHERE key = 'MX')),
('ZAC', 'Zacatecas', (SELECT country_id FROM countries WHERE key = 'MX')),
('CDX', 'Ciudad de México', (SELECT country_id FROM countries WHERE key = 'MX')),

-- US
('AL', 'Alabama', (SELECT country_id FROM countries WHERE key = 'US')),
('AK', 'Alaska', (SELECT country_id FROM countries WHERE key = 'US')),
('AZ', 'Arizona', (SELECT country_id FROM countries WHERE key = 'US')),
('AR', 'Arkansas', (SELECT country_id FROM countries WHERE key = 'US')),
('CA', 'California', (SELECT country_id FROM countries WHERE key = 'US')),
('CO', 'Colorado', (SELECT country_id FROM countries WHERE key = 'US')),
('CT', 'Connecticut', (SELECT country_id FROM countries WHERE key = 'US')),
('DE', 'Delaware', (SELECT country_id FROM countries WHERE key = 'US')),
('FL', 'Florida', (SELECT country_id FROM countries WHERE key = 'US')),
('GA', 'Georgia', (SELECT country_id FROM countries WHERE key = 'US')),
('HI', 'Hawaii', (SELECT country_id FROM countries WHERE key = 'US')),
('ID', 'Idaho', (SELECT country_id FROM countries WHERE key = 'US')),
('IL', 'Illinois', (SELECT country_id FROM countries WHERE key = 'US')),
('IN', 'Indiana', (SELECT country_id FROM countries WHERE key = 'US')),
('IA', 'Iowa', (SELECT country_id FROM countries WHERE key = 'US')),
('KS', 'Kansas', (SELECT country_id FROM countries WHERE key = 'US')),
('KY', 'Kentucky', (SELECT country_id FROM countries WHERE key = 'US')),
('LA', 'Louisiana', (SELECT country_id FROM countries WHERE key = 'US')),
('ME', 'Maine', (SELECT country_id FROM countries WHERE key = 'US')),
('MD', 'Maryland', (SELECT country_id FROM countries WHERE key = 'US')),
('MA', 'Massachusetts', (SELECT country_id FROM countries WHERE key = 'US')),
('MI', 'Michigan', (SELECT country_id FROM countries WHERE key = 'US')),
('MN', 'Minnesota', (SELECT country_id FROM countries WHERE key = 'US')),
('MS', 'Mississippi', (SELECT country_id FROM countries WHERE key = 'US')),
('MO', 'Missouri', (SELECT country_id FROM countries WHERE key = 'US')),
('MT', 'Montana', (SELECT country_id FROM countries WHERE key = 'US')),
('NE', 'Nebraska', (SELECT country_id FROM countries WHERE key = 'US')),
('NV', 'Nevada', (SELECT country_id FROM countries WHERE key = 'US')),
('NH', 'New Hampshire', (SELECT country_id FROM countries WHERE key = 'US')),
('NJ', 'New Jersey', (SELECT country_id FROM countries WHERE key = 'US')),
('NM', 'New Mexico', (SELECT country_id FROM countries WHERE key = 'US')),
('NY', 'New York', (SELECT country_id FROM countries WHERE key = 'US')),
('NC', 'North Carolina', (SELECT country_id FROM countries WHERE key = 'US')),
('ND', 'North Dakota', (SELECT country_id FROM countries WHERE key = 'US')),
('OH', 'Ohio', (SELECT country_id FROM countries WHERE key = 'US')),
('OK', 'Oklahoma', (SELECT country_id FROM countries WHERE key = 'US')),
('OR', 'Oregon', (SELECT country_id FROM countries WHERE key = 'US')),
('PA', 'Pennsylvania', (SELECT country_id FROM countries WHERE key = 'US')),
('RI', 'Rhode Island', (SELECT country_id FROM countries WHERE key = 'US')),
('SC', 'South Carolina', (SELECT country_id FROM countries WHERE key = 'US')),
('SD', 'South Dakota', (SELECT country_id FROM countries WHERE key = 'US')),
('TN', 'Tennessee', (SELECT country_id FROM countries WHERE key = 'US')),
('TX', 'Texas', (SELECT country_id FROM countries WHERE key = 'US')),
('UT', 'Utah', (SELECT country_id FROM countries WHERE key = 'US')),
('VT', 'Vermont', (SELECT country_id FROM countries WHERE key = 'US')),
('VA', 'Virginia', (SELECT country_id FROM countries WHERE key = 'US')),
('WA', 'Washington', (SELECT country_id FROM countries WHERE key = 'US')),
('WV', 'West Virginia', (SELECT country_id FROM countries WHERE key = 'US')),
('WI', 'Wisconsin', (SELECT country_id FROM countries WHERE key = 'US')),
('WY', 'Wyoming', (SELECT country_id FROM countries WHERE key = 'US'));

-------------------------------------------------
-- 4. Categories
-------------------------------------------------
INSERT INTO categories (name, description) VALUES
('Smartphones', 'Mobile phones and related accessories.'),
('Laptops & Computers', 'Laptops, desktops, monitors, and PC components.'),
('Audio & Speakers', 'Headphones, speakers, and high-fidelity audio gear.'),
('Tablets & E-Readers', 'Electronic tablets and digital book readers.'),
('Video Games & Consoles', 'Gaming consoles, games, and gaming accessories.'),
('Wearables', 'Smartwatches, fitness bands, and AR/VR glasses.'),
('TV & Home Theater', 'Televisions, projectors, and home media players.'),
('Smart Home', 'IoT devices, smart lighting, and home security.'),
('Cameras & Photography', 'Digital cameras, lenses, and photography drones.'),
('Computer Peripherals', 'Keyboards, mice, printers, and external storage.');

-------------------------------------------------
-- 5. Branches
-------------------------------------------------
INSERT INTO branches (name, address, state_id) VALUES
('Apple Antara', 'Av. Ejército Nacional Mexicano 843, Polanco, Miguel Hidalgo, 11520 CDMX', (SELECT state_id FROM states WHERE key = 'CDX')),
('Apple Fifth Avenue', '767 5th Ave, New York, NY 10153', (SELECT state_id FROM states WHERE key = 'NY')),
('Apple Union Square', '300 Post St, San Francisco, CA 94108', (SELECT state_id FROM states WHERE key = 'CA')),
('Samsung Store Andares', 'Blvd. Puerta de Hierro 4965, Puerta de Hierro, 45116 Zapopan', (SELECT state_id FROM states WHERE key = 'JAL')),
('Samsung Experience Store Galleria', '5015 Westheimer Rd, Houston, TX 77056', (SELECT state_id FROM states WHERE key = 'TX')),
('Bose Santa Fe', 'Vasco de Quiroga 3800, Lomas de Santa Fe, Cuajimalpa de Morelos, 05109 CDMX', (SELECT state_id FROM states WHERE key = 'CDX')),
('Bose The Grove', '189 The Grove Dr, Los Angeles, CA 90036', (SELECT state_id FROM states WHERE key = 'CA')),
('Best Buy Union Square', '52 E 14th St, New York, NY 10003', (SELECT state_id FROM states WHERE key = 'NY')),
('MacStore Plaza Mayor', 'Blvd. Juan Alonso de Torres 2002, Valle del Campestre, 37150 León', (SELECT state_id FROM states WHERE key = 'GUA')),
('iShop Mixup Angelópolis', 'Blvd. del Niño Poblano 2510, Reserva Territorial Atlixcáyotl, 72810 Puebla', (SELECT state_id FROM states WHERE key = 'PUE')),
('Sony Store Perisur', 'Anillo Perif. 4690, Insurgentes Cuicuilco, Coyoacán, 04500 CDMX', (SELECT state_id FROM states WHERE key = 'CDX')),
('Nintendo New York', '10 Rockefeller Plaza, New York, NY 10020', (SELECT state_id FROM states WHERE key = 'NY')),
('Microsoft Store Ala Moana', '1450 Ala Moana Blvd, Honolulu, HI 96814', (SELECT state_id FROM states WHERE key = 'HI')),
('Razer Store Las Vegas', '3545 S Las Vegas Blvd, Las Vegas, NV 89109', (SELECT state_id FROM states WHERE key = 'NV')),
('Xiaomi Store Parque Delta', 'Av. Cuauhtémoc 462, Piedad Narvarte, Benito Juárez, 03000 CDMX', (SELECT state_id FROM states WHERE key = 'CDX')),
('Huawei Store Galerías Monterrey', 'Av Insurgentes 2500, Vista Hermosa, 64620 Monterrey', (SELECT state_id FROM states WHERE key = 'NLE')),
('Alienware Miami', '11401 NW 12th St, Miami, FL 33172', (SELECT state_id FROM states WHERE key = 'FL')),
('JBL Store SoHo', '19 E Houston St, New York, NY 10012', (SELECT state_id FROM states WHERE key = 'NY')),
('LG Brand Store Cancún', 'Blvd. Kukulcan Km 1.5, Zona Hotelera, 77500 Cancún', (SELECT state_id FROM states WHERE key = 'ROO')),
('Garmin Chicago', '663 N Michigan Ave, Chicago, IL 60611', (SELECT state_id FROM states WHERE key = 'IL'));

-------------------------------------------------
-- 6. Products
-------------------------------------------------
INSERT INTO products (category_id, sku, barcode, name, base_price)
SELECT 
    c.category_id, 
    p.sku, 
    p.barcode, 
    p.name, 
    p.base_price::NUMERIC(10, 2)
FROM (
    VALUES 
    ('Smartphones', 'APP-IP15PM-256', '0194253474810', 'Apple iPhone 15 Pro Max 256GB Titanium', 1199.00),
    ('Smartphones', 'SAM-S24U-512', '8806095362940', 'Samsung Galaxy S24 Ultra 512GB Titanium Black', 1419.99),
    ('Smartphones', 'GOO-PIX8P-128', '0810029938830', 'Google Pixel 8 Pro 128GB Obsidian', 999.00),
    ('Smartphones', 'XIA-14U-512', '6941812759950', 'Xiaomi 14 Ultra 512GB Black', 1299.00),
    ('Smartphones', 'HUA-P60P-256', '6941487291240', 'Huawei P60 Pro 256GB Rococo Pearl', 1050.00),
    ('Smartphones', 'SON-X1V-256', '4546821921350', 'Sony Xperia 1 V 256GB Black', 1198.00),
    ('Smartphones', 'MOT-EDGE-512', '0840023225880', 'Motorola Edge+ 2023 512GB Interstellar Black', 799.99),
    ('Smartphones', 'ONP-12-256', '6921815623080', 'OnePlus 12 256GB Silky Black', 799.99),
    ('Smartphones', 'ASU-ROG8P-512', '4711387431280', 'ASUS ROG Phone 8 Pro 512GB Phantom Black', 1199.99),
    ('Smartphones', 'NOT-PH2-256', '5060978200150', 'Nothing Phone (2) 256GB Dark Grey', 699.00),

    ('Laptops & Computers', 'APP-MBP16-M3M', '0194253812940', 'Apple MacBook Pro 16" M3 Max 1TB Space Black', 3499.00),
    ('Laptops & Computers', 'ALI-M18-R2', '0884116452810', 'Alienware m18 R2 Gaming Laptop RTX 4080', 2499.99),
    ('Laptops & Computers', 'MIC-SLS2-512', '0889842953210', 'Microsoft Surface Laptop Studio 2 i7 16GB', 2399.00),
    ('Laptops & Computers', 'RAZ-BLA16-4090', '8100561439200', 'Razer Blade 16 Mini-LED RTX 4090', 4299.99),
    ('Laptops & Computers', 'DEL-XPS15-OLED', '0884116421990', 'Dell XPS 15 OLED i9 1TB SSD', 1999.00),
    ('Laptops & Computers', 'LEN-X1C-G11', '0196802145880', 'Lenovo ThinkPad X1 Carbon Gen 11', 1699.00),
    ('Laptops & Computers', 'ASU-G14-4060', '4711387023150', 'ASUS ROG Zephyrus G14 OLED RTX 4060', 1599.99),
    ('Laptops & Computers', 'HP-SPEC14-X360', '0197029531840', 'HP Spectre x360 14" 2-in-1', 1399.99),
    ('Laptops & Computers', 'LG-GRAM17-1TB', '0719192648520', 'LG Gram 17" Lightweight Laptop i7 1TB', 1699.00),
    ('Laptops & Computers', 'APP-MACST-M2U', '0194253147850', 'Apple Mac Studio M2 Ultra 64GB RAM', 3999.00),

    ('Audio & Speakers', 'BOS-QCU-BLK', '0178178491020', 'Bose QuietComfort Ultra Headphones Black', 429.00),
    ('Audio & Speakers', 'SON-WH1000XM5', '0272429235810', 'Sony WH-1000XM5 Wireless Noise Canceling', 398.00),
    ('Audio & Speakers', 'APP-APP2-USB', '0194253397640', 'Apple AirPods Pro (2nd Gen) USB-C', 249.00),
    ('Audio & Speakers', 'JBL-FLIP6-BLK', '0500363841520', 'JBL Flip 6 Portable Bluetooth Speaker', 129.95),
    ('Audio & Speakers', 'SEN-MOM4-BLK', '0615104368140', 'Sennheiser Momentum 4 Wireless', 349.95),
    ('Audio & Speakers', 'BOS-SB900-BLK', '0178178301540', 'Bose Smart Soundbar 900 Dolby Atmos', 899.00),
    ('Audio & Speakers', 'SON-ARC-BLK', '8782690098150', 'Sonos Arc Premium Smart Soundbar', 899.00),
    ('Audio & Speakers', 'RAZ-BSV2P-BLK', '8100561405160', 'Razer BlackShark V2 Pro Gaming Headset', 199.99),
    ('Audio & Speakers', 'MAR-STAN3-BLK', '7340055385410', 'Marshall Stanmore III Bluetooth Speaker', 379.99),
    ('Audio & Speakers', 'UE-MEGA3-BLK', '0978551410250', 'Ultimate Ears MEGABOOM 3 Wireless Speaker', 199.99),

    ('Tablets & E-Readers', 'APP-IPDP12-256', '0194253301450', 'Apple iPad Pro 12.9" M2 256GB Space Gray', 1199.00),
    ('Tablets & E-Readers', 'SAM-TABS9U-512', '8806095034150', 'Samsung Galaxy Tab S9 Ultra 512GB', 1319.99),
    ('Tablets & E-Readers', 'MIC-SURP9-16G', '0889842915640', 'Microsoft Surface Pro 9 i7 16GB 256GB', 1599.99),
    ('Tablets & E-Readers', 'AMZ-KPW-SIG', '0840080534210', 'Amazon Kindle Paperwhite Signature Edition', 189.99),
    ('Tablets & E-Readers', 'APP-IPDM6-64G', '0194252819540', 'Apple iPad Mini 6th Gen 64GB Starlight', 499.00),
    ('Tablets & E-Readers', 'LEN-TABP12-PRO', '0195890254180', 'Lenovo Tab P12 Pro 12.6" AMOLED', 699.99),
    ('Tablets & E-Readers', 'XIA-PAD6-128', '6941812712580', 'Xiaomi Pad 6 11" 128GB Gravity Gray', 399.00),
    ('Tablets & E-Readers', 'RMK-RM2-EINK', '0709004941010', 'Remarkable 2 E-Ink Tablet', 299.00),
    ('Tablets & E-Readers', 'ONY-BOOX-NA3C', '6949801831450', 'Onyx Boox Note Air 3 C Color E-Ink', 499.99),
    ('Tablets & E-Readers', 'SAM-TABA9P-64G', '8806095318540', 'Samsung Galaxy Tab A9+ 64GB Graphite', 219.99),

    ('Video Games & Consoles', 'SON-PS5-DISC', '0711719541020', 'Sony PlayStation 5 Console', 499.99),
    ('Video Games & Consoles', 'NIN-SWOLED-WHT', '0454965939330', 'Nintendo Switch OLED Model White Joy-Con', 349.99),
    ('Video Games & Consoles', 'MIC-XSX-1TB', '0889842640720', 'Microsoft Xbox Series X 1TB Console', 499.99),
    ('Video Games & Consoles', 'VAL-SD-OLED512', '0814585021540', 'Valve Steam Deck OLED 512GB', 549.00),
    ('Video Games & Consoles', 'ASU-ROGALLY-Z1E', '4711387145280', 'ASUS ROG Ally Z1 Extreme Gaming Handheld', 699.99),
    ('Video Games & Consoles', 'SON-DS5-WHT', '0711719541080', 'Sony DualSense Wireless Controller White', 69.99),
    ('Video Games & Consoles', 'NIN-SWPRO-BLK', '0454965901610', 'Nintendo Switch Pro Controller', 69.99),
    ('Video Games & Consoles', 'MIC-XBE2-BLK', '0889842514790', 'Xbox Elite Wireless Controller Series 2', 179.99),
    ('Video Games & Consoles', 'MET-Q3-128G', '0815820023410', 'Meta Quest 3 128GB VR Headset', 499.99),
    ('Video Games & Consoles', 'RAZ-WOLV2-PRO', '8100561428540', 'Razer Wolverine V2 Pro Controller', 249.99),

    ('Wearables', 'APP-AWU2-TIT', '0194253814590', 'Apple Watch Ultra 2 Titanium Case', 799.00),
    ('Wearables', 'GAR-FEN7X-SS', '0753759281540', 'Garmin Fenix 7X Sapphire Solar Black', 899.99),
    ('Wearables', 'SAM-GW6C-47', '8806095071250', 'Samsung Galaxy Watch 6 Classic 47mm', 399.99),
    ('Wearables', 'OUR-RING3-HOR', '0810086371580', 'Oura Ring Gen3 Horizon Stealth', 349.00),
    ('Wearables', 'FIT-CHG6-BLK', '0810038854120', 'Fitbit Charge 6 Fitness Tracker Obsidian', 159.95),
    ('Wearables', 'HUA-WGT4-46', '6941487295140', 'Huawei Watch GT 4 46mm Black', 249.00),
    ('Wearables', 'XIA-BAND8-BLK', '6941812725140', 'Xiaomi Smart Band 8 Graphite Black', 49.99),
    ('Wearables', 'GOO-PW2-OBS', '0810029939510', 'Google Pixel Watch 2 Obsidian', 349.99),
    ('Wearables', 'AMZ-GTR4-BLK', '6972596105410', 'Amazfit GTR 4 Smartwatch Superspeed Black', 199.99),
    ('Wearables', 'WHO-40-BLK', '0850027159180', 'Whoop 4.0 Health and Fitness Tracker', 239.00),

    ('TV & Home Theater', 'LG-65C3-OLED', '1951740523480', 'LG 65" Class C3 Series OLED 4K TV', 1699.99),
    ('TV & Home Theater', 'SAM-75QN900C', '8872767281450', 'Samsung 75" Neo QLED 8K QN900C', 4499.99),
    ('TV & Home Theater', 'SON-65A95L', '0272429274510', 'Sony 65" BRAVIA XR A95L OLED 4K', 3299.99),
    ('TV & Home Theater', 'TCL-85QM8', '8460420512840', 'TCL 85" QM8 QLED 4K Smart TV', 1799.99),
    ('TV & Home Theater', 'HIS-100U8K', '8881430154280', 'Hisense 100" U8K Mini-LED ULED TV', 3999.99),
    ('TV & Home Theater', 'APP-ATV4K-128', '0194253154820', 'Apple TV 4K 128GB (3rd Generation)', 149.00),
    ('TV & Home Theater', 'ROK-ULT-4K', '8296100045180', 'Roku Ultra 4K Streaming Device', 99.99),
    ('TV & Home Theater', 'NVI-SHIELD-PRO', '8126740234150', 'NVIDIA Shield TV Pro Streaming Media Player', 199.99),
    ('TV & Home Theater', 'EPS-HC5050UB', '0103439431850', 'Epson Home Cinema 5050UB 4K PRO-UHD', 2999.99),
    ('TV & Home Theater', 'SAM-FRAME55', '8872767351840', 'Samsung The Frame 55" QLED 4K', 1499.99),

    ('Smart Home', 'PHI-HUE-START', '0466775485560', 'Philips Hue White & Color Ambiance Starter Kit', 199.99),
    ('Smart Home', 'GOO-NEST-L3', '8115010185140', 'Google Nest Learning Thermostat (3rd Gen)', 249.00),
    ('Smart Home', 'AMZ-ECHO-STU', '0840080512840', 'Amazon Echo Studio Smart Speaker', 199.99),
    ('Smart Home', 'RNG-VD-PRO2', '0842861114510', 'Ring Video Doorbell Pro 2', 249.99),
    ('Smart Home', 'AUG-LOCK-V4', '8539750065410', 'August Wi-Fi Smart Lock (4th Gen)', 229.99),
    ('Smart Home', 'ARL-PRO4-3PK', '1931081412580', 'Arlo Pro 4 Spotlight Camera (3-Pack)', 399.99),
    ('Smart Home', 'XIA-CAM360', '6934177715420', 'Xiaomi Mi Home Security Camera 360', 39.99),
    ('Smart Home', 'NAN-TRI-START', '0840005514280', 'Nanoleaf Shapes Triangles Smarter Kit', 199.99),
    ('Smart Home', 'ECO-THERM-PRM', '8281560021480', 'Ecobee Smart Thermostat Premium', 249.99),
    ('Smart Home', 'TPL-KASA-P4', '8400307045180', 'TP-Link Kasa Smart Plug Ultra Mini (4-Pack)', 29.99),

    ('Cameras & Photography', 'SON-A7IV-BODY', '0272429241580', 'Sony Alpha a7 IV Mirrorless Camera Body', 2498.00),
    ('Cameras & Photography', 'CAN-R5-BODY', '0138033251480', 'Canon EOS R5 Mirrorless Camera Body', 3399.00),
    ('Cameras & Photography', 'NIK-Z8-BODY', '0182080174150', 'Nikon Z8 Mirrorless Camera Body', 3996.95),
    ('Cameras & Photography', 'DJI-MINI4P-RC2', '1900210854120', 'DJI Mini 4 Pro Drone with RC 2 Controller', 959.00),
    ('Cameras & Photography', 'GOP-H12-BLK', '8182790295140', 'GoPro HERO12 Black Action Camera', 399.99),
    ('Cameras & Photography', 'FUJ-X100VI-SLV', '0741012135840', 'Fujifilm X100VI Digital Camera Silver', 1599.00),
    ('Cameras & Photography', 'PAN-GH6-BODY', '8851703814520', 'Panasonic LUMIX GH6 Camera Body', 1697.99),
    ('Cameras & Photography', 'DJI-OSMOP3', '1900210931540', 'DJI Osmo Pocket 3 Gimbal Camera', 519.00),
    ('Cameras & Photography', 'SIG-2470-DG', '0851265782540', 'Sigma 24-70mm f/2.8 DG DN Art Lens', 1099.00),
    ('Cameras & Photography', 'INS-X3-360', '8421261025140', 'Insta360 X3 360 Action Camera', 399.99),

    ('Computer Peripherals', 'LOG-MXM3S-BLK', '0978551731540', 'Logitech MX Master 3S Wireless Mouse', 99.99),
    ('Computer Peripherals', 'RAZ-DAV3-PRO', '8100561465280', 'Razer DeathAdder V3 Pro Gaming Mouse', 149.99),
    ('Computer Peripherals', 'APP-MKB-TID', '0194252514820', 'Apple Magic Keyboard with Touch ID', 149.00),
    ('Computer Peripherals', 'KEY-Q1PRO-BLK', '4895248815410', 'Keychron Q1 Pro Mechanical Keyboard', 199.00),
    ('Computer Peripherals', 'SAM-T7S-2TB', '8872766321450', 'Samsung T7 Shield 2TB Portable SSD', 149.99),
    ('Computer Peripherals', 'LG-27GR95QE', '1951740452810', 'LG 27" UltraGear OLED Gaming Monitor', 999.99),
    ('Computer Peripherals', 'COR-K100-RGB', '8400066251480', 'Corsair K100 RGB Mechanical Gaming Keyboard', 229.99),
    ('Computer Peripherals', 'ELG-SD-MK2', '0840006645180', 'Elgato Stream Deck MK.2', 149.99),
    ('Computer Peripherals', 'WD-SN850X-2TB', '0718037895140', 'WD Black SN850X 2TB NVMe SSD', 159.99),
    ('Computer Peripherals', 'LOG-BRIO-4K', '0978551254180', 'Logitech Brio 4K Webcam', 169.99)
) AS p(category_name, sku, barcode, name, base_price)
JOIN categories c ON c.name = p.category_name;


-------------------------------------------------
-- 7. Sales
-------------------------------------------------
DO $$
DECLARE
    v_sales_count INT := 10000;
    v_branch_id INT;
    v_sale_date TIMESTAMP WITH TIME ZONE;
    v_method payment_method;
    v_ticket_number VARCHAR(100);
    v_new_sale_id INT;
    v_num_items INT;
    v_product_id INT;
    v_quantity NUMERIC(8, 3);
    v_unit_price NUMERIC(10, 2);
    v_subtotal NUMERIC(12, 2);
    v_total_amount NUMERIC(12, 2);
    v_product_ids INT[];
    v_used_products INT[];
    i INT;
    j INT;
BEGIN
    -- Mapping of what products each branch is allowed to sell
    CREATE TEMP TABLE branch_product_map AS
    SELECT b.branch_id, array_agg(p.product_id) as allowed_products
    FROM branches b, products p
    WHERE 
        b.name ILIKE '%Best Buy%' OR 
        (b.name ILIKE '%Apple%' AND p.name ILIKE '%Apple%') OR
        (b.name ILIKE '%MacStore%' AND p.name ILIKE '%Apple%') OR
        (b.name ILIKE '%iShop%' AND p.name ILIKE '%Apple%') OR
        (b.name ILIKE '%Samsung%' AND p.name ILIKE '%Samsung%') OR
        (b.name ILIKE '%Bose%' AND p.name ILIKE '%Bose%') OR
        (b.name ILIKE '%Sony%' AND (p.name ILIKE '%Sony%' OR p.name ILIKE '%PlayStation%' OR p.name ILIKE '%DualSense%')) OR
        (b.name ILIKE '%Nintendo%' AND p.name ILIKE '%Nintendo%') OR
        (b.name ILIKE '%Microsoft%' AND (p.name ILIKE '%Microsoft%' OR p.name ILIKE '%Xbox%')) OR
        (b.name ILIKE '%Razer%' AND p.name ILIKE '%Razer%') OR
        (b.name ILIKE '%Xiaomi%' AND p.name ILIKE '%Xiaomi%') OR
        (b.name ILIKE '%Huawei%' AND p.name ILIKE '%Huawei%') OR
        (b.name ILIKE '%Alienware%' AND p.name ILIKE '%Alienware%') OR
        (b.name ILIKE '%JBL%' AND p.name ILIKE '%JBL%') OR
        (b.name ILIKE '%LG%' AND p.name ILIKE '%LG%') OR
        (b.name ILIKE '%Garmin%' AND p.name ILIKE '%Garmin%')
    GROUP BY b.branch_id;

    -- Sales Generation
    FOR i IN 1..v_sales_count LOOP
        
        -- Random branch
        SELECT branch_id, allowed_products INTO v_branch_id, v_product_ids
        FROM branch_product_map
        ORDER BY random() LIMIT 1;

        -- Random date within the last 2 years
        v_sale_date := NOW() - (random() * (interval '2 years'));
        
        -- Payment method distribution (approx. 75% card, 25% cash)
        IF random() < 0.75 THEN
            v_method := 'CARD';
        ELSE
            v_method := 'CASH';
        END IF;

        -- Unique ticket number
        v_ticket_number := 'TKT-' || to_char(v_sale_date, 'YYYYMMDD') || '-' || lpad(i::TEXT, 6, '0');

        -- New Sale
        INSERT INTO sales (branch_id, sale_date, total_amount, method, ticket_number)
        VALUES (v_branch_id, v_sale_date, 0, v_method, v_ticket_number)
        RETURNING sale_id INTO v_new_sale_id;

        -- Generate Sale Details (1 to 4 unique items per ticket)
        v_total_amount := 0;
        v_num_items := floor(random() * 4 + 1); 
        v_used_products := ARRAY[]::INT[];

        FOR j IN 1..v_num_items LOOP
            
            -- Random product from specific branch's allowed catalog
            v_product_id := v_product_ids[floor(random() * array_length(v_product_ids, 1) + 1)];
            
            -- Ensure no duplicate products on the same ticket
            IF NOT (v_product_id = ANY(v_used_products)) THEN
                v_used_products := array_append(v_used_products, v_product_id);

                -- Random quantity (1 to 10 units)
                v_quantity := floor(random() * 10 + 1);

                -- Fetch base price
                SELECT base_price INTO v_unit_price FROM products WHERE product_id = v_product_id;
                
                -- Realistic pricing: Apply a random 0% to 5% discount
                v_unit_price := v_unit_price * (1 - (random() * 0.05));
                v_unit_price := round(v_unit_price, 2);

                -- Calculate subtotal
                v_subtotal := round(v_quantity * v_unit_price, 2);
                v_total_amount := v_total_amount + v_subtotal;

                -- Insert detail row
                INSERT INTO sale_details (sale_id, product_id, quantity, unit_price, subtotal)
                VALUES (v_new_sale_id, v_product_id, v_quantity, v_unit_price, v_subtotal);
            END IF;
            
        END LOOP;

        -- Update the parent sale record with the accurate grand total
        UPDATE sales SET total_amount = v_total_amount WHERE sale_id = v_new_sale_id;

    END LOOP;

    -- Clean up
    DROP TABLE branch_product_map;
END $$;