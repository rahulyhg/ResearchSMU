-- MySQL Script generated by MySQL Workbench
-- 04/21/15 19:15:45
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema DBGUI
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `DBGUI` ;

-- -----------------------------------------------------
-- Schema DBGUI
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `DBGUI` ;
USE `DBGUI` ;

-- -----------------------------------------------------
-- Table `DBGUI`.`Users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DBGUI`.`Users` ;

CREATE TABLE IF NOT EXISTS `DBGUI`.`Users` (
  `user_ID` INT NOT NULL AUTO_INCREMENT,
  `active` TINYINT(1) NOT NULL DEFAULT 1,
  `dateCreated` DATE NOT NULL,
  `dateDeactivated` DATE NULL,
  `fName` VARCHAR(45) NOT NULL,
  `lName` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `userType` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`user_ID`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DBGUI`.`Admin`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DBGUI`.`Admin` ;

CREATE TABLE IF NOT EXISTS `DBGUI`.`Admin` (
  `user_ID` INT NOT NULL,
  PRIMARY KEY (`user_ID`),
  INDEX `fk_Admin_Users1_idx` (`user_ID` ASC),
  CONSTRAINT `fk_Admin_Users1`
    FOREIGN KEY (`user_ID`)
    REFERENCES `DBGUI`.`Users` (`user_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DBGUI`.`Institution`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DBGUI`.`Institution` ;

CREATE TABLE IF NOT EXISTS `DBGUI`.`Institution` (
  `inst_ID` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`inst_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DBGUI`.`Department`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DBGUI`.`Department` ;

CREATE TABLE IF NOT EXISTS `DBGUI`.`Department` (
  `dept_ID` INT NOT NULL AUTO_INCREMENT,
  `inst_ID` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`dept_ID`),
  INDEX `fk_Department_Institution1_idx` (`inst_ID` ASC),
  CONSTRAINT `fk_Department_Institution1`
    FOREIGN KEY (`inst_ID`)
    REFERENCES `DBGUI`.`Institution` (`inst_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DBGUI`.`Student`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DBGUI`.`Student` ;

CREATE TABLE IF NOT EXISTS `DBGUI`.`Student` (
  `user_ID` INT NOT NULL,
  `inst_ID` INT NOT NULL,
  `dept_ID` INT NOT NULL,
  `graduateStudent` TINYINT(1) NOT NULL,
  `resume` VARCHAR(45) NOT NULL,
  `loginCount` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`user_ID`),
  INDEX `fk_General_Users_idx` (`user_ID` ASC),
  INDEX `fk_General_Institution1_idx` (`inst_ID` ASC),
  INDEX `fk_Student_Department1_idx` (`dept_ID` ASC),
  CONSTRAINT `fk_General_Users`
    FOREIGN KEY (`user_ID`)
    REFERENCES `DBGUI`.`Users` (`user_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_General_Institution1`
    FOREIGN KEY (`inst_ID`)
    REFERENCES `DBGUI`.`Institution` (`inst_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Student_Department1`
    FOREIGN KEY (`dept_ID`)
    REFERENCES `DBGUI`.`Department` (`dept_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DBGUI`.`Faculty`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DBGUI`.`Faculty` ;

CREATE TABLE IF NOT EXISTS `DBGUI`.`Faculty` (
  `user_ID` INT NOT NULL,
  `inst_ID` INT NOT NULL,
  `dept_ID` INT NOT NULL,
  `loginCount` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`user_ID`),
  INDEX `fk_Faculty_Users1_idx` (`user_ID` ASC),
  INDEX `fk_Faculty_Institution1_idx` (`inst_ID` ASC),
  INDEX `fk_Faculty_Department1_idx` (`dept_ID` ASC),
  CONSTRAINT `fk_Faculty_Users1`
    FOREIGN KEY (`user_ID`)
    REFERENCES `DBGUI`.`Users` (`user_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Faculty_Institution1`
    FOREIGN KEY (`inst_ID`)
    REFERENCES `DBGUI`.`Institution` (`inst_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Faculty_Department1`
    FOREIGN KEY (`dept_ID`)
    REFERENCES `DBGUI`.`Department` (`dept_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DBGUI`.`ResearchOp`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DBGUI`.`ResearchOp` ;

CREATE TABLE IF NOT EXISTS `DBGUI`.`ResearchOp` (
  `researchOp_ID` INT NOT NULL AUTO_INCREMENT,
  `user_ID` INT NOT NULL,
  `inst_ID` INT NOT NULL,
  `dept_ID` INT NOT NULL,
  `active` TINYINT(1) NOT NULL DEFAULT 1,
  `dateCreated` DATE NOT NULL,
  `dateDeactivated` DATE NULL,
  `name` VARCHAR(48) CHARACTER SET 'utf8' NOT NULL,
  `description` MEDIUMTEXT CHARACTER SET 'utf8' NOT NULL,
  `startDate` DATE NOT NULL,
  `endDate` DATE NULL,
  `numPositions` INT NOT NULL,
  `paid` TINYINT(1) NOT NULL DEFAULT 0,
  `workStudy` TINYINT(1) NOT NULL DEFAULT 0,
  `acceptsUndergrad` TINYINT(1) NOT NULL DEFAULT 1,
  `acceptsGrad` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`researchOp_ID`),
  INDEX `fk_ROP_Institution1_idx` (`inst_ID` ASC),
  INDEX `fk_ROP_Department1_idx` (`dept_ID` ASC),
  INDEX `fk_ResearchOp_Faculty1_idx` (`user_ID` ASC),
  CONSTRAINT `fk_ROP_Institution1`
    FOREIGN KEY (`inst_ID`)
    REFERENCES `DBGUI`.`Institution` (`inst_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ROP_Department1`
    FOREIGN KEY (`dept_ID`)
    REFERENCES `DBGUI`.`Department` (`dept_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ResearchOp_Faculty1`
    FOREIGN KEY (`user_ID`)
    REFERENCES `DBGUI`.`Faculty` (`user_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DBGUI`.`Applicants`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DBGUI`.`Applicants` ;

CREATE TABLE IF NOT EXISTS `DBGUI`.`Applicants` (
  `researchOp_ID` INT NOT NULL,
  `user_ID` INT NOT NULL,
  `status` VARCHAR(45) NOT NULL DEFAULT 'Pending' COMMENT 'Pending, Accepted, or Rejected',
  `dateSubmitted` DATETIME NOT NULL,
  `dateResponded` DATETIME NULL,
  INDEX `fk_Applicants_ROP1_idx` (`researchOp_ID` ASC),
  PRIMARY KEY (`researchOp_ID`, `user_ID`),
  INDEX `fk_Applicants_Student1_idx` (`user_ID` ASC),
  CONSTRAINT `fk_Applicants_ROP1`
    FOREIGN KEY (`researchOp_ID`)
    REFERENCES `DBGUI`.`ResearchOp` (`researchOp_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Applicants_Student1`
    FOREIGN KEY (`user_ID`)
    REFERENCES `DBGUI`.`Student` (`user_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DBGUI`.`Password`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DBGUI`.`Password` ;

CREATE TABLE IF NOT EXISTS `DBGUI`.`Password` (
  `user_ID` INT NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  INDEX `fk_Password_Users1_idx` (`user_ID` ASC),
  PRIMARY KEY (`user_ID`, `password`),
  CONSTRAINT `fk_Password_Users1`
    FOREIGN KEY (`user_ID`)
    REFERENCES `DBGUI`.`Users` (`user_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `DBGUI`.`Uploads`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DBGUI`.`Uploads` ;

CREATE TABLE IF NOT EXISTS `DBGUI`.`Uploads` (
	id INT(4) NOT NULL AUTO_INCREMENT PRIMARY KEY, 
	description CHAR(50), 
	form_Data LONGBLOB, 
	filename CHAR(50), 
	filesize CHAR(50), 
	filetype CHAR(50) )
ENGINE = InnoDB;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

USE 'DBGUI';

INSERT INTO Users(user_ID, active, dateCreated, fname, lname, email) VALUES

	(013, TRUE, '2012-03-13', "Dwayne The Rock", "Johnson", "rock@smu.edu"),
	(001, TRUE, '2012-04-14', "Macho Man Randy", "Savage", "savage@smu.edu"),
	(002, TRUE, '2013-05-15', "Hulk", "Hogan", "hulk@smu.edu"),
	(003, TRUE, '2013-06-16', "George", "Harrison", "george@smu.edu"),
	(004, TRUE, '2013-07-17', "Paul", "McCartney", "paul@smu.edu"),
	(005, TRUE, '2013-08-18', "Ringo", "Starr", "ringo@smu.edu"),
	(006, TRUE, '2013-09-19', "Barack", "Obama", "obama@smu.edu"),
	(007, TRUE, '2014-10-20', "Dubya", "Bush", "dubya@smu.edu"),
	(008, TRUE, '2013-11-21', "Willy", "Clinton", "bill@smu.edu"),
	(009, TRUE, '2012-12-22', "John", "Dorian", "dorian@smu.edu"),
	(010, TRUE, '2011-01-23', "Elliot", "Reid", "ET@smu.edu"),
	(011, TRUE, '2012-02-24', "Christopher", "Turkleton", "turk@smu.edu"),
	(012, TRUE, '2013-03-25', "Crazy", "Hooch", "hooch@smu.edu");
	
INSERT INTO Admin(user_ID) VALUES

	(006),
	(007),
	(008);

INSERT INTO Institution(inst_ID, name) VALUES

	(001, "Dedman"),
	(002, "Cox"),
	(003, "Meadows"),
	(004, "Simmons"),
	(005, "Lyle");

INSERT INTO Department(dept_ID, inst_ID, name) VALUES

	(003, 001, "Anthropology"),
	(008, 001, "Biological Sciences"),
	(010, 001, "Chemistry"),
	(018, 001, "Earth Sciences"),
	(019, 001, "Economics"),
	(021, 001, "English"),
	(025, 001, "History"),
	(030, 001, "Math"),
	(033, 001, "Philosophy"),
	(034, 001, "Physics"),
	(035, 001, "Political Science"),
	(036, 001, "Psychology"),
	(038, 001, "Religious Sciences"),
	(041, 001, "Sociology"),
	(042, 001, "Statistical Sciences"),
	(046, 001, "World Languages"),
	(011, 005, "Civil & Environmental Engineering"),
	(013, 005, "Computer Science & Engineering"),
	(020, 005, "Electrical Engineering"),
	(028, 005, "Management Sciences"),
	(031, 005, "Mechanical Engineering"),
	(001, 002, "Accounting"),
	(023, 002, "Finance"),
	(029, 002, "Marketing"),
	(027, 002, "Management"),
	(037, 002, "Real Estate"),
	(039, 002, "Risk Management"),
	(002, 003, "Advertising"),
	(005, 003, "Art"),
	(006, 003, "Art History"),
	(007, 003, "Art Management"),
	(012, 003, "Communication"),
	(015, 003, "Creative Computing"),
	(016, 003, "Dance"),
	(022, 003, "Film & Media Arts"),
	(026, 003, "Journalism"),
	(032, 003, "Music"),
	(044, 003, "Theatre"),
	(004, 004, "Applied Physiology"),
	(014, 004, "Counseling"),
	(017, 004, "Dispute Resolution"),
	(024, 004, "Higher Education"),
	(040, 004, "Sports Management"),
	(043, 004, "Teacher Education"),
	(045, 004, "Wellness");
	
INSERT INTO Student(user_ID, inst_ID, dept_ID, resume, graduateStudent, loginCount) VALUES

	(003, 005, 013, "dont got one", FALSE, 3),
	(004, 005, 020, "https:lol.com", FALSE, 2),
	(005, 005, 031, "yes", FALSE, 5),
	(009, 005, 028, "holy dookies", FALSE, 6),
	(010, 005, 031, "UUUUUHHHH", FALSE, 4),
	(011, 005, 031, "no", TRUE, 1),
	(012, 005, 027, "hue", TRUE, 2);

INSERT INTO Faculty(user_ID, inst_ID, dept_ID, loginCount) VALUES

	(013, 005, 013, 3),
	(001, 005, 020, 2),
	(002, 005, 027, 4);

INSERT INTO ResearchOp(researchOp_ID, user_ID, inst_ID, dept_ID, active, dateCreated, name, description, startDate, numPositions, paid, workStudy, acceptsUndergrad, acceptsGrad) VALUES

	(100, 013, 005, 013, TRUE, '2014-11-22', "Virtual Girlfriend Creation", "Create a girlfriend so you do not have to talk to real people!", '2015-01-15', 12, true, false, true, false),
	(101, 002, 005, 020, TRUE, '2014-11-23', "Business in America", "You live in America. Do the business OUR way.", '2015-03-13', 5, true,  false, false, true),
	(102, 001, 005, 031, TRUE, '2014-11-24', "Future of Art", "Art did not used to suck, maybe it will not suck in the future?", '2015-06-02', 1, false,  false, false, true),
	(103, 001, 005, 028, TRUE, '2014-11-25', "Dissection of Cow Stomach", "We made sure to kill the cow right after it ate. DIG IN!", '2015-10-30', 5, false, true, false, false),
	(104, 002, 005, 027, TRUE, '2014-11-26', "Court Behavior Analysis", "Psychopaths act weird in courtroom situations. Let us watch what they do.", '2015-12-12', 3, true, true, true, true);	
	
INSERT INTO Applicants(researchOp_ID, user_ID, status, dateSubmitted) VALUES
	(102, 009, "no?", '2015-12-14 00:00:00'),
	(103, 010, "yes please.", '2015-12-15 05:24:23'),
	(104, 011, "MMM WATCHU SAAAAAAAAY", '2015-12-13 06:21:30');

INSERT INTO Password(user_ID, password) VALUES
	(013, "ImCookingNoodles"),
	(001, "CreamOfTheCrop"),
	(002, "OhYeahBrother"),
	(003, "password1"),
	(004, "password2"),
	(005, "password3"),
	(006, "MyCountry"),
	(007, "NucularWar"),
	(008, "WhoIsMonica"),
	(009, "EEEEEEEAGLE"),
	(010, "Bajingo"),
	(011, "SurgeryR00lz"),
	(012, "CRaaaAaAAzy");
