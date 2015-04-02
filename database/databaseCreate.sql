-- MySQL Script generated by MySQL Workbench
-- 04/02/15 15:29:18
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
  `user_ID` INT NOT NULL,
  `saltValue` VARCHAR(45) NOT NULL,
  `fName` VARCHAR(45) NOT NULL,
  `lName` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`user_ID`))
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
  `resume` VARCHAR(45) NOT NULL,
  `graduateStudent` TINYINT(1) NOT NULL,
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
  `name` VARCHAR(45) NOT NULL,
  `dateCreated` VARCHAR(45) NOT NULL,
  `dateFinished` VARCHAR(45) NOT NULL,
  `num_Positions` INT NOT NULL,
  `applicant_Count` INT NOT NULL,
  `paid` TINYINT(1) NOT NULL,
  `work_study` TINYINT(1) NOT NULL,
  `graduate` TINYINT(1) NOT NULL,
  `undergraduate` TINYINT(1) NOT NULL,
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


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
