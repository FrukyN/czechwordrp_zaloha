CREATE TABLE IF NOT EXISTS `spravni_rizeni` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `policista` VARCHAR(100),
    `civilista_identifier` VARCHAR(60),
    `civilista_jmeno` VARCHAR(100),
    `duvod` TEXT,
    `castka` INT,
    `detaily` TEXT,
    `stav` VARCHAR(20) DEFAULT 'ceka'
);