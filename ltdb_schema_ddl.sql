-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema ltdb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `ltdb` ;

-- -----------------------------------------------------
-- Schema ltdb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ltdb` DEFAULT CHARACTER SET utf8 ;
USE `ltdb` ;

-- -----------------------------------------------------
-- Table `ltdb`.`users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ltdb`.`users` ;

CREATE TABLE IF NOT EXISTS `ltdb`.`users` (
  `user_id` INT(11) NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(100) NOT NULL,
  `login` VARCHAR(100) NOT NULL,
  `passwd` VARCHAR(250) NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `middle_name` VARCHAR(45) NULL DEFAULT NULL,
  `gender` CHAR(1) NULL DEFAULT NULL,
  `upd_ts` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `photo_path` VARCHAR(150) NULL DEFAULT NULL,
  `is_external` BIT(1) NOT NULL DEFAULT b'0',
  `last_login` TIMESTAMP NULL DEFAULT NULL,
  `failed_logins` SMALLINT(6) NOT NULL DEFAULT '0',
  `verified` BIT(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`user_id`),
  UNIQUE INDEX `login_UNIQUE` (`login` ASC),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 29
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `ltdb`.`content`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ltdb`.`content` ;

CREATE TABLE IF NOT EXISTS `ltdb`.`content` (
  `content_id` INT(11) NOT NULL AUTO_INCREMENT,
  `content_type` CHAR(1) NOT NULL,
  `url` VARCHAR(350) NOT NULL,
  `title` VARCHAR(250) NOT NULL,
  `user_id` INT(11) NOT NULL,
  `is_private` BIT(1) NOT NULL,
  `description` TEXT NULL DEFAULT NULL,
  `upd_ts` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `tags` VARCHAR(300) NULL DEFAULT NULL,
  PRIMARY KEY (`content_id`),
  INDEX `fk_videos_users_idx` (`user_id` ASC),
  FULLTEXT INDEX `title_desc_FT_idx` (`title` ASC, `description` ASC, `tags` ASC),
  CONSTRAINT `fk_videos_users`
    FOREIGN KEY (`user_id`)
    REFERENCES `ltdb`.`users` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 58
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `ltdb`.`trails`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ltdb`.`trails` ;

CREATE TABLE IF NOT EXISTS `ltdb`.`trails` (
  `trail_id` INT(11) NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(100) NOT NULL,
  `is_private` BIT(1) NOT NULL,
  `user_id` INT(11) NOT NULL,
  `upd_ts` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `tags` VARCHAR(300) NULL DEFAULT NULL,
  PRIMARY KEY (`trail_id`),
  INDEX `fk_trail_user_idx` (`user_id` ASC),
  FULLTEXT INDEX `title_FT_idx` (`title` ASC, `tags` ASC),
  CONSTRAINT `fk_trail_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `ltdb`.`users` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 41
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `ltdb`.`trail_items`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ltdb`.`trail_items` ;

CREATE TABLE IF NOT EXISTS `ltdb`.`trail_items` (
  `item_id` INT(11) NOT NULL AUTO_INCREMENT,
  `trail_id` INT(11) NOT NULL,
  `content_id` INT(11) NOT NULL,
  `seq_no` SMALLINT(6) NOT NULL,
  `upd_ts` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`item_id`),
  INDEX `fk_trail_item_1_idx` (`trail_id` ASC),
  INDEX `fk_trail_item_video_idx` (`content_id` ASC),
  CONSTRAINT `fk_trail_item_video`
    FOREIGN KEY (`content_id`)
    REFERENCES `ltdb`.`content` (`content_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_trail_item_trail`
    FOREIGN KEY (`trail_id`)
    REFERENCES `ltdb`.`trails` (`trail_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 102
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `ltdb`.`comments`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ltdb`.`comments` ;

CREATE TABLE IF NOT EXISTS `ltdb`.`comments` (
  `comment_id` INT(11) NOT NULL AUTO_INCREMENT,
  `author` INT(11) NOT NULL,
  `comment` TEXT NOT NULL,
  `level` SMALLINT(6) NOT NULL DEFAULT '0',
  `trail_id` INT(11) NULL DEFAULT NULL,
  `item_id` INT(11) NOT NULL,
  `subject` VARCHAR(150) NOT NULL,
  `in_reply_to` INT(11) NULL DEFAULT NULL,
  `tags` VARCHAR(150) NULL DEFAULT NULL,
  `upd_ts` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ins_ts` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`comment_id`),
  INDEX `fk_comments_1_idx` (`author` ASC),
  INDEX `fk_comments_trail_item_idx` (`item_id` ASC),
  INDEX `fk_comments_parent_idx` (`in_reply_to` ASC),
  INDEX `fk_comments_trail_idx` (`trail_id` ASC),
  FULLTEXT INDEX `comment_FT_idx` (`comment` ASC, `subject` ASC, `tags` ASC),
  CONSTRAINT `fk_comments_trail_item`
    FOREIGN KEY (`item_id`)
    REFERENCES `ltdb`.`trail_items` (`item_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_comments_author`
    FOREIGN KEY (`author`)
    REFERENCES `ltdb`.`users` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_comments_parent`
    FOREIGN KEY (`in_reply_to`)
    REFERENCES `ltdb`.`comments` (`comment_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 63
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `ltdb`.`analytics`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ltdb`.`analytics` ;

CREATE TABLE IF NOT EXISTS `ltdb`.`analytics` (
  `analytics_id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `action` VARCHAR(20) NOT NULL,
  `user_id` INT(11) NULL DEFAULT NULL,
  `trail_id` INT(11) NULL DEFAULT NULL,
  `trail_item_id` INT(11) NULL DEFAULT NULL,
  `comment_id` INT(11) NULL DEFAULT NULL,
  `action_ts` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`analytics_id`),
  INDEX `fk_analytics_user_idx` (`user_id` ASC),
  INDEX `fk_analytics_trail_idx` (`trail_id` ASC),
  INDEX `fk_analytics_trail_item_idx` (`trail_item_id` ASC),
  INDEX `fk_analytics_comment_idx` (`comment_id` ASC),
  CONSTRAINT `fk_analytics_trail_item`
    FOREIGN KEY (`trail_item_id`)
    REFERENCES `ltdb`.`trail_items` (`item_id`)
    ON DELETE SET NULL
    ON UPDATE SET NULL,
  CONSTRAINT `fk_analytics_comment`
    FOREIGN KEY (`comment_id`)
    REFERENCES `ltdb`.`comments` (`comment_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_analytics_trail`
    FOREIGN KEY (`trail_id`)
    REFERENCES `ltdb`.`trails` (`trail_id`)
    ON DELETE SET NULL
    ON UPDATE SET NULL,
  CONSTRAINT `fk_analytics_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `ltdb`.`users` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 1824
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `ltdb`.`questions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ltdb`.`questions` ;

CREATE TABLE IF NOT EXISTS `ltdb`.`questions` (
  `question_id` INT(11) NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(50) NOT NULL,
  `type` VARCHAR(5) NOT NULL,
  `question` TEXT NOT NULL,
  `author` INT(11) NOT NULL,
  `feedback` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`question_id`),
  INDEX `fk_question_author_idx` (`author` ASC),
  FULLTEXT INDEX `FT_title_question_idx` (`title` ASC, `question` ASC),
  CONSTRAINT `fk_question_author`
    FOREIGN KEY (`author`)
    REFERENCES `ltdb`.`users` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `ltdb`.`answer_options`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ltdb`.`answer_options` ;

CREATE TABLE IF NOT EXISTS `ltdb`.`answer_options` (
  `ans_opt_id` INT(11) NOT NULL AUTO_INCREMENT,
  `question_id` INT(11) NOT NULL,
  `answer` TEXT NOT NULL,
  `author` INT(11) NOT NULL,
  `is_correct` BIT(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`ans_opt_id`),
  INDEX `fk_answer_options_questions_idx` (`question_id` ASC),
  INDEX `fk_answer_options_author_idx` (`author` ASC),
  CONSTRAINT `fk_answer_options_author`
    FOREIGN KEY (`author`)
    REFERENCES `ltdb`.`users` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_answer_options_questions`
    FOREIGN KEY (`question_id`)
    REFERENCES `ltdb`.`questions` (`question_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `ltdb`.`assessments`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ltdb`.`assessments` ;

CREATE TABLE IF NOT EXISTS `ltdb`.`assessments` (
  `assessment_id` INT(11) NOT NULL AUTO_INCREMENT,
  `is_published` BIT(1) NOT NULL DEFAULT b'0',
  `title` VARCHAR(100) NOT NULL,
  `description` TEXT NULL DEFAULT NULL,
  `upd_ts` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `author` INT(11) NOT NULL,
  `wrong_ans_points` TINYINT(4) NULL DEFAULT NULL,
  `correct_ans_points` TINYINT(4) NULL DEFAULT NULL,
  `randomize_questions` BIT(1) NOT NULL DEFAULT b'0',
  `randomize_answers` BIT(1) NOT NULL DEFAULT b'0',
  `allotted_minutes` SMALLINT(6) NULL DEFAULT NULL,
  `show_score` BIT(1) NOT NULL DEFAULT b'1',
  `open_time` DATETIME NULL DEFAULT NULL,
  `close_time` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`assessment_id`),
  INDEX `fk_assessments_users_idx` (`author` ASC),
  CONSTRAINT `fk_assessments_users`
    FOREIGN KEY (`author`)
    REFERENCES `ltdb`.`users` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `ltdb`.`assessment_questions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ltdb`.`assessment_questions` ;

CREATE TABLE IF NOT EXISTS `ltdb`.`assessment_questions` (
  `assess_question_id` INT(11) NOT NULL AUTO_INCREMENT,
  `assessment_id` INT(11) NOT NULL,
  `question_id` INT(11) NOT NULL,
  `points` TINYINT(4) NULL DEFAULT NULL,
  PRIMARY KEY (`assess_question_id`),
  INDEX `fk_assessment_questions_1_idx` (`assessment_id` ASC),
  INDEX `fk_assessment_questions_qust_idx` (`question_id` ASC),
  CONSTRAINT `fk_assessment_questions_assess`
    FOREIGN KEY (`assessment_id`)
    REFERENCES `ltdb`.`assessments` (`assessment_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assessment_questions_qust`
    FOREIGN KEY (`question_id`)
    REFERENCES `ltdb`.`questions` (`question_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `ltdb`.`assessment_submissions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ltdb`.`assessment_submissions` ;

CREATE TABLE IF NOT EXISTS `ltdb`.`assessment_submissions` (
  `submission_id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `student` INT(11) NOT NULL,
  `assessment_id` INT(11) NOT NULL,
  `is_draft` BIT(1) NOT NULL DEFAULT b'0',
  `submitted_on` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `start_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`submission_id`),
  INDEX `fk_assessment_submissions_student_idx` (`student` ASC),
  INDEX `fk_assessment_submissions_assessment_idx` (`assessment_id` ASC),
  CONSTRAINT `fk_assessment_submissions_assessment`
    FOREIGN KEY (`assessment_id`)
    REFERENCES `ltdb`.`assessments` (`assessment_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_assessment_submissions_student`
    FOREIGN KEY (`student`)
    REFERENCES `ltdb`.`users` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `ltdb`.`audit_logs`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ltdb`.`audit_logs` ;

CREATE TABLE IF NOT EXISTS `ltdb`.`audit_logs` (
  `audit_log_id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `app_user` VARCHAR(45) NOT NULL,
  `activity` VARCHAR(100) NOT NULL,
  `client_ip` VARCHAR(15) NOT NULL,
  `action_ts` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`audit_log_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 19776
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `ltdb`.`onetime_auth`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ltdb`.`onetime_auth` ;

CREATE TABLE IF NOT EXISTS `ltdb`.`onetime_auth` (
  `auth_id` INT(11) NOT NULL AUTO_INCREMENT,
  `user_id` INT(11) NOT NULL,
  `uuid_part` VARCHAR(40) NOT NULL,
  `expires_on` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ins_ts` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`auth_id`),
  INDEX `fk_reset_requests_user_idx` (`user_id` ASC),
  CONSTRAINT `fk_reset_requests_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `ltdb`.`users` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `ltdb`.`roles`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ltdb`.`roles` ;

CREATE TABLE IF NOT EXISTS `ltdb`.`roles` (
  `role_id` INT(11) NOT NULL AUTO_INCREMENT,
  `role_code` VARCHAR(10) NOT NULL,
  `description` VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (`role_id`),
  UNIQUE INDEX `role_cd_UNIQUE` (`role_code` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `ltdb`.`submission_responses`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ltdb`.`submission_responses` ;

CREATE TABLE IF NOT EXISTS `ltdb`.`submission_responses` (
  `response_id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `submission_id` BIGINT(20) NOT NULL,
  `assess_question_id` INT(11) NOT NULL,
  `ans_opt_id` INT(11) NULL DEFAULT NULL,
  `response` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`response_id`),
  INDEX `fk_submission_responses_sub_idx` (`submission_id` ASC),
  INDEX `fk_submission_responses_aq_idx` (`assess_question_id` ASC),
  INDEX `fk_submission_responses_ans_opt_idx` (`ans_opt_id` ASC),
  CONSTRAINT `fk_submission_responses_ans_opt`
    FOREIGN KEY (`ans_opt_id`)
    REFERENCES `ltdb`.`answer_options` (`ans_opt_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_submission_responses_aq`
    FOREIGN KEY (`assess_question_id`)
    REFERENCES `ltdb`.`assessment_questions` (`assess_question_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_submission_responses_sub`
    FOREIGN KEY (`submission_id`)
    REFERENCES `ltdb`.`assessment_submissions` (`submission_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `ltdb`.`subscriptions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ltdb`.`subscriptions` ;

CREATE TABLE IF NOT EXISTS `ltdb`.`subscriptions` (
  `subsc_id` INT(11) NOT NULL AUTO_INCREMENT,
  `trail_id` INT(11) NOT NULL,
  `user_id` INT(11) NOT NULL,
  `upd_ts` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`subsc_id`),
  UNIQUE INDEX `unique_subscription` (`trail_id` ASC, `user_id` ASC),
  INDEX `fk_subscriptions_trails_idx` (`trail_id` ASC),
  INDEX `fk_subscriptions_users_idx` (`user_id` ASC),
  CONSTRAINT `fk_subscriptions_trails`
    FOREIGN KEY (`trail_id`)
    REFERENCES `ltdb`.`trails` (`trail_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_subscriptions_users`
    FOREIGN KEY (`user_id`)
    REFERENCES `ltdb`.`users` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `ltdb`.`trail_assessments`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ltdb`.`trail_assessments` ;

CREATE TABLE IF NOT EXISTS `ltdb`.`trail_assessments` (
  `trail_assess_id` INT(11) NOT NULL AUTO_INCREMENT,
  `trail_id` INT(11) NULL DEFAULT NULL,
  `assessment_id` INT(11) NOT NULL,
  PRIMARY KEY (`trail_assess_id`),
  UNIQUE INDEX `UC_trail_assess` (`trail_id` ASC, `assessment_id` ASC),
  INDEX `fk_trail_assessments_trail_idx` (`trail_id` ASC),
  INDEX `fk_trail_assessments_assess_idx` (`assessment_id` ASC),
  CONSTRAINT `fk_trail_assessments_trail`
    FOREIGN KEY (`trail_id`)
    REFERENCES `ltdb`.`trails` (`trail_id`)
    ON DELETE SET NULL
    ON UPDATE SET NULL,
  CONSTRAINT `fk_trail_assessments_assess`
    FOREIGN KEY (`assessment_id`)
    REFERENCES `ltdb`.`assessments` (`assessment_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `ltdb`.`user_roles`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `ltdb`.`user_roles` ;

CREATE TABLE IF NOT EXISTS `ltdb`.`user_roles` (
  `user_role_id` INT(11) NOT NULL AUTO_INCREMENT,
  `user_id` INT(11) NULL DEFAULT NULL,
  `role_id` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`user_role_id`),
  UNIQUE INDEX `uq_user_role` (`user_id` ASC, `role_id` ASC),
  INDEX `fk_user_roles_1_idx` (`user_id` ASC),
  INDEX `fk_user_roles_2_idx` (`role_id` ASC),
  CONSTRAINT `fk_user_roles_1`
    FOREIGN KEY (`user_id`)
    REFERENCES `ltdb`.`users` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_roles_2`
    FOREIGN KEY (`role_id`)
    REFERENCES `ltdb`.`roles` (`role_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
