INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_brewery', 'brewery', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_brewery', 'brewery', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('society_brewery', 'brewery', 1)
;

INSERT INTO `jobs` (name, label) VALUES
	('brewery', 'Brewery')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('brewery',0,'recruit','Recruit',120,'{}','{}'),
	('brewery',1,'novice','Novice',240,'{}','{}'),
	('brewery',2,'experienced','Experienced',360,'{}','{}'),
	('brewery',3,'advanced',"Advanced",480,'{}','{}'),
	('brewery',4,'manager',"Manager",480,'{}','{}'),
	('brewery',5,'boss','Boss',500,'{}','{}')
;