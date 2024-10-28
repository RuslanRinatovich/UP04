-- public.additional_services определение

-- Drop table

-- DROP TABLE additional_services;

CREATE TABLE additional_services (
	additional_service_id int8 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE) NOT NULL,
	title varchar(100) NOT NULL,
	price float4 NOT NULL,
	description varchar NOT NULL,
	CONSTRAINT additional_services_pk PRIMARY KEY (additional_service_id)
);


-- public.clients определение

-- Drop table

-- DROP TABLE clients;

CREATE TABLE clients (
	client_id int8 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE) NOT NULL,
	first_name varchar(50) NOT NULL,
	last_name varchar(50) NOT NULL,
	middle_name varchar(50) NULL,
	birth_date date NOT NULL,
	birth_place varchar NOT NULL,
	phone varchar NOT NULL,
	email varchar(100) NOT NULL,
	passport_series varchar(4) NOT NULL,
	passport_number varchar(6) NOT NULL,
	passport_issue_place varchar NOT NULL,
	passport_issue_date date NOT NULL,
	address varchar NOT NULL,
	"password" varchar NOT NULL,
	CONSTRAINT clients_pk PRIMARY KEY (client_id),
	CONSTRAINT clients_unique UNIQUE (email)
);


-- public.equipment определение

-- Drop table

-- DROP TABLE equipment;

CREATE TABLE equipment (
	equipment_id int8 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE) NOT NULL,
	title varchar(100) NOT NULL,
	CONSTRAINT equipment_pk PRIMARY KEY (equipment_id)
);


-- public.roles определение

-- Drop table

-- DROP TABLE roles;

CREATE TABLE roles (
	role_id int8 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE) NOT NULL,
	title varchar(20) NOT NULL,
	CONSTRAINT roles_pk PRIMARY KEY (role_id)
);


-- public.room_categories определение

-- Drop table

-- DROP TABLE room_categories;

CREATE TABLE room_categories (
	room_category_id int8 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE) NOT NULL,
	title varchar(100) NOT NULL,
	description varchar NOT NULL,
	price float4 NOT NULL,
	CONSTRAINT room_categories_pk PRIMARY KEY (room_category_id)
);


-- public.room_status определение

-- Drop table

-- DROP TABLE room_status;

CREATE TABLE room_status (
	room_status_id int8 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE) NOT NULL,
	title varchar(20) NOT NULL,
	CONSTRAINT room_status_pk PRIMARY KEY (room_status_id)
);


-- public.staff_categories определение

-- Drop table

-- DROP TABLE staff_categories;

CREATE TABLE staff_categories (
	employee_category_id int8 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE) NOT NULL,
	title varchar(100) NOT NULL,
	CONSTRAINT staff_categories_pk PRIMARY KEY (employee_category_id)
);


-- public.rooms определение

-- Drop table

-- DROP TABLE rooms;

CREATE TABLE rooms (
	room_id int8 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE) NOT NULL,
	floor_number int8 NOT NULL,
	"number" int4 NOT NULL,
	room_category_id int8 NOT NULL,
	room_status_id int8 NOT NULL,
	CONSTRAINT rooms_pk PRIMARY KEY (room_id),
	CONSTRAINT rooms_fk FOREIGN KEY (room_category_id) REFERENCES room_categories(room_category_id) ON DELETE SET NULL,
	CONSTRAINT rooms_fk_1 FOREIGN KEY (room_status_id) REFERENCES room_status(room_status_id) ON DELETE SET NULL
);


-- public.staff определение

-- Drop table

-- DROP TABLE staff;

CREATE TABLE staff (
	employee_id int8 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE) NOT NULL,
	firts_name varchar(100) NOT NULL,
	last_name varchar(100) NOT NULL,
	middle_name varchar(100) NOT NULL,
	employee_category_id int8 NOT NULL,
	phone varchar NOT NULL,
	CONSTRAINT staff_pk PRIMARY KEY (employee_id),
	CONSTRAINT staff_fk FOREIGN KEY (employee_category_id) REFERENCES staff_categories(employee_category_id) ON DELETE SET NULL
);


-- public.users определение

-- Drop table

-- DROP TABLE users;

CREATE TABLE users (
	username varchar(50) NOT NULL,
	"password" varchar NOT NULL,
	role_id int8 NOT NULL,
	employee_id int8 NULL,
	CONSTRAINT users_pk PRIMARY KEY (username),
	CONSTRAINT staff_fk FOREIGN KEY (employee_id) REFERENCES staff(employee_id) ON DELETE SET NULL,
	CONSTRAINT users_fk FOREIGN KEY (role_id) REFERENCES roles(role_id) ON DELETE SET NULL
);


-- public.bookings определение

-- Drop table

-- DROP TABLE bookings;

CREATE TABLE bookings (
	booking_id int8 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE) NOT NULL,
	client_id int8 NOT NULL,
	date_start date NOT NULL,
	date_end date NULL,
	room_id int8 NOT NULL,
	CONSTRAINT bookings_pk PRIMARY KEY (booking_id),
	CONSTRAINT bookings_fk FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE SET NULL,
	CONSTRAINT bookings_fk_1 FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);


-- public.housekeepings определение

-- Drop table

-- DROP TABLE housekeepings;

CREATE TABLE housekeepings (
	housekeeping_id int8 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1 NO CYCLE) NOT NULL,
	employee_id int8 NOT NULL,
	floor_number int8 NOT NULL,
	cleaning_date date NOT NULL,
	CONSTRAINT housekeepings_pk PRIMARY KEY (housekeeping_id),
	CONSTRAINT housekeepings_staff_fk FOREIGN KEY (employee_id) REFERENCES staff(employee_id) ON DELETE SET NULL
);


-- public.room_equipment определение

-- Drop table

-- DROP TABLE room_equipment;

CREATE TABLE room_equipment (
	room_id int8 NOT NULL,
	equipment_id int8 NOT NULL,
	CONSTRAINT room_equipment_pk PRIMARY KEY (room_id, equipment_id),
	CONSTRAINT room_equipment_fk FOREIGN KEY (room_id) REFERENCES rooms(room_id) ON DELETE SET NULL,
	CONSTRAINT room_equipment_fk_1 FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id) ON DELETE SET NULL
);


-- public.booking_additional_services определение

-- Drop table

-- DROP TABLE booking_additional_services;

CREATE TABLE booking_additional_services (
	booking_id int8 NOT NULL,
	additional_service_id int8 NOT NULL,
	count int4 NOT NULL,
	CONSTRAINT booking_additional_services_pk PRIMARY KEY (booking_id, additional_service_id),
	CONSTRAINT booking_additional_services_fk FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE SET NULL,
	CONSTRAINT booking_additional_services_fk_1 FOREIGN KEY (additional_service_id) REFERENCES additional_services(additional_service_id) ON DELETE SET NULL
);

INSERT INTO additional_services (title,price,description) VALUES
	 ('Дополнительный завтрак',750.0,'Ресторан отеля предлагает большой выбор блюд традиционной европейской кухни. Горячие и холодные закуски, гарниры и основные блюда, а также салаты и десерты. Система «шведский стол»'),
	 ('Дополнительный ужин ',1100.0,'Все гости нашего отеля при заселении получают возможность питаться в ресторане отеля по системе «шведский стол», но за дополнительную плату заказывают дополнительный ужин в отеле.'),
	 ('Зал для конференций (большой) ',5500.0,'Большой конференц-зал находится на втором этаже гостиницы. Здесь имеется небольшой подиум для выступающих, рассадка –театр. Имеется естественное освещение, также предусмотрены жалюзи для затемнения. '),
	 ('Зал для конференций (малый) ',3500.0,'Малый конференц-зал представляет собой небольшое помещение со строгим офисным дизайном, оборудованное мобильной мебелью (столы, стулья, трибуна) и современной техникой. Имеется естественное освещение, также предусмотрены жалюзи для затемнения. Зал находится на первом этаже гостиницы и вмещает до 25 человек. '),
	 ('Бизнес центр',400.0,'К услугам гостей аренда компьютера с доступом в интернет, сканер, принтер.'),
	 ('Прачечная',0.0,'Мы предлагаем своим гостям услуги современной прачечной. 
У нас вы можете заказать все виды услуг прачечной, связанные с машинной стиркой. 
Мы выстираем, высушим, отгладим и доставим в номер.'),
	 ('Банкетный зал ',2500.0,'Рядом с конференц-залом расположен банкетный зал, где Вам помогут организовать кофе-паузу или фуршет.'),
	 ('Тренажерный зал',0.0,'Расположен на одиннадцатом этаже гостиницы. Для проживающих в гостинице посещение тренажерного зала бесплатно.'),
	 ('Парковка',750.0,'Для удобства наших гостей, возле центрального входа расположена охраняемая парковка. '),
	 ('Камера хранения ',50.0,'В гостинице работает круглосуточная камера хранения. ');
INSERT INTO booking_additional_services (booking_id,additional_service_id,count) VALUES
	 (1,1,2),
	 (1,2,2),
	 (1,9,7),
	 (2,1,3),
	 (2,2,3),
	 (2,4,3),
	 (2,9,7),
	 (3,6,8),
	 (3,8,8),
	 (3,5,4);
INSERT INTO bookings (client_id,date_start,date_end,room_id) VALUES
	 (1,'2024-10-28','2024-11-03',1),
	 (3,'2024-10-21','2024-10-29',5),
	 (4,'2024-10-14','2024-10-27',3);
INSERT INTO clients (first_name,last_name,middle_name,birth_date,birth_place,phone,email,passport_series,passport_number,passport_issue_place,passport_issue_date,address,"password") VALUES
	 ('Торсунов','Торсунов','Лаврентиич','1991-03-22','Россия, г. Одинцово, Зеленая ул., д. 21 кв.101','+7 (959) 503-31-89','nikolay7818@gmail.com','4488','406881','Отделением УФМС России в г. Обнинск','2024-06-24','Россия, г. Кызыл, Чапаева ул., д. 12 кв.82','1'),
	 ('Ноздрёва','Любовь','Марковна','1979-05-04','Россия, г. Обнинск, Советская ул., д. 14 кв.77','+7 (931) 167-29-68','lyubov.nozdreva@hotmail.com','4682','4682','Отделом внутренних дел России по г. Москва','2015-07-15','Россия, г. Нижний Новгород, Ленина В.И.ул., д. 8 кв.11','2'),
	 ('Вырыпаев','Георгий','Степанович','2021-08-13','Россия, г. Арзамас, Зеленая ул., д. 8 кв.200','+7 (982) 858-44-29','georgiy95@rambler.ru','4392','298362','ОУФМС России по г. Самара','2021-08-13','Россия, г. Самара, Мира ул., д. 23 кв.49','3');
INSERT INTO equipment (title) VALUES
	 ('Телевизор'),
	 ('Холодильник'),
	 ('Wi-Fi'),
	 ('телефон'),
	 ('односпальная кровать'),
	 ('письменный стол'),
	 ('зеркало'),
	 ('шкаф для одежды'),
	 ('двуспальная кровать'),
	 ('полутораспальная кровать');
INSERT INTO housekeepings (employee_id,floor_number,cleaning_date) VALUES
	 (4,1,'2024-10-21'),
	 (1,2,'2024-10-21'),
	 (3,3,'2024-10-21'),
	 (4,1,'2024-10-22'),
	 (1,2,'2024-10-22'),
	 (3,3,'2024-10-22'),
	 (4,1,'2024-10-23'),
	 (1,2,'2024-10-23'),
	 (3,3,'2024-10-23'),
	 (4,1,'2024-10-24');
INSERT INTO housekeepings (employee_id,floor_number,cleaning_date) VALUES
	 (1,2,'2024-10-24'),
	 (3,3,'2024-10-25');
INSERT INTO roles (title) VALUES
	 ('руководитель'),
	 ('сотрудник');
INSERT INTO room_categories (title,description,price) VALUES
	 ('Одноместный эконом','Однокомнатный номер с ванной комнатой. В номере: одна кровать, платяной шкаф, прикроватные тумбочки, письменный стол, стулья или мягкое кресло, зеркало, телефон, ТВ, холодильник, чайная пара, набор полотенец и косметических принадлежностей для ванной комнаты.',2250.0),
	 ('Одноместный стандарт','Однокомнатный номер с ванной комнатой. В номере: одна кровать, платяной шкаф, прикроватные тумбочки, письменный стол, стулья или мягкое кресло, зеркало, телефон, ТВ, холодильник, чайная пара, набор полотенец и косметических принадлежностей для ванной комнаты.',2520.0),
	 ('Эконом двухместный с 2 раздельными кроватями','Однокомнатный номер с ванной комнатой. В номере: две кровати, платяной шкаф, прикроватные тумбочки, письменный стол, стулья или мягкое кресло, зеркало, телефон, ТВ,холодильник, чайная пара, набор полотенец и косметических принадлежностей для ванной комнаты.',2700.0),
	 ('Стандарт двухместный с 2 раздельными кроватями','Однокомнатный номер с ванной комнатой. В номере: две кровати, платяной шкаф, прикроватные тумбочки, письменный стол, стулья или мягкое кресло, зеркало, телефон, ТВ, холодильник, чайная пара, набор полотенец и косметических принадлежностей для ванной комнаты.
',2970.0),
	 ('Двухкомнатный двухместный стандарт с 1 или 2 кроватями','Двухкомнатный номер с ванной комнатой. В номере: одна двуспальная или две раздельные кровати, платяной шкаф, прикроватные тумбочки, письменный стол, стулья или мягкое кресло, зеркало, телефон, ТВ, холодильник, чайная пара, набор полотенец и косметических принадлежностей для ванной комнаты.',3600.0),
	 ('Бизнес с 1 или 2 кроватями','Однокомнатный номер с ванной комнатой. В номере: одна двуспальная или две раздельные кровати, платяной шкаф, прикроватные тумбочки, письменный стол, стулья или мягкое кресло, зеркало, телефон, ТВ, холодильник, чайная пара, набор полотенец и косметических принадлежностей для ванной комнаты.',3780.0),
	 ('Студия','Однокомнатный номер с ванной комнатой. В номере: одна двуспальная, платяной шкаф, прикроватные тумбочки, письменный стол, стулья или мягкое кресло, зеркало, телефон, ТВ, холодильник, чайная пара, набор полотенец и косметических принадлежностей для ванной комнаты.',4050.0),
	 ('Люкс с 2 двуспальными кроватями','Трехкомнатный номер с ванной комнатой. В номере: 2 двуспальные кровати, платяной шкаф, прикроватные тумбочки, письменный стол, стулья или мягкое кресло, зеркало, телефон, ТВ, холодильник, чайная пара, набор полотенец и косметических принадлежностей для ванной комнаты.',4500.0),
	 ('3-местный бюджет','Туалет и ванная комната общая на 2 номера. В номере: три кровати, платяной шкаф, прикроватные тумбочки, письменный стол, стулья или мягкое кресло, зеркало, телефон, ТВ, холодильник, чайная пара, набор полотенец и косметических принадлежностей для ванной комнаты.',3150.0);
INSERT INTO room_equipment (room_id,equipment_id) VALUES
	 (1,1),
	 (1,2),
	 (1,3),
	 (1,4),
	 (1,5),
	 (1,6),
	 (1,7),
	 (1,8),
	 (2,1),
	 (2,2);
INSERT INTO room_equipment (room_id,equipment_id) VALUES
	 (2,3),
	 (2,4),
	 (2,5),
	 (2,6),
	 (2,7);
INSERT INTO room_status (title) VALUES
	 ('Свободен'),
	 ('Занят'),
	 ('Чистый'),
	 ('Назначен к уборке'),
	 ('Грязный');
INSERT INTO rooms (floor_number,"number",room_category_id,room_status_id) VALUES
	 (1,101,1,2),
	 (1,102,2,1),
	 (1,103,3,4),
	 (2,201,4,1),
	 (2,202,5,2),
	 (2,203,6,3),
	 (2,204,7,4),
	 (3,301,8,1),
	 (3,302,9,2),
	 (3,303,9,2);
INSERT INTO staff (firts_name,last_name,middle_name,employee_category_id,phone) VALUES
	 ('Горев','Филипп','Романович',1,'+7 (958) 569-65-50'),
	 ('Аксенова','Аксенова','Антоновна',3,'+7 (956) 554-55-87'),
	 ('Бурова','Ирина','Игнатьевна',3,'+7 (916) 485-16-23'),
	 ('Арчибасов','Артем','Егорович',2,'+7 (966) 615-44-40'),
	 ('Яшихина','Анфиса','Марковна',2,'+7 (952) 680-81-98'),
	 ('Карантирова','Карантирова','Адамовна',3,'+7 (938) 246-55-51');
INSERT INTO staff_categories (title) VALUES
	 ('руководитель'),
	 ('сотрудник'),
	 ('уборщица');
INSERT INTO users (username,"password",role_id,employee_id) VALUES
	 ('filip','1',1,2),
	 ('anfisa','2',2,6),
	 ('artem','2',2,5);


