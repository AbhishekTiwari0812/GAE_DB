# ========= Query 01
INSERT INTO ltdb.analytics(action, user_id, trail_id,
trail_item_id, comment_id)
VALUES(${action}, ${userId}, ${trailId}, ${trailItemId}, ${commentId});

# ========= Query 02
select count(*) from ltdb.users;

# ========= Query 03
SELECT
a.address_id as addressId,
a.street_address as streetAddress,
a.city_vpo as cityOrVpo,
a.pin_code as postalCode,
a.home_phone as homePhone,
a.address_district_id as district
FROM ltdb.addresses a
WHERE a.address_id=${id}

# ========= Query 04
INSERT INTO ltdb.onetime_auth
(user_id, uuid_part, expires_on)
VALUES(${userId}, ${uuid}, ${expiresOn});

# ========= Query 05
DELETE FROM ltdb.onetime_auth
WHERE user_id=${userId} AND uuid_part = ${uuid}

# ========= Query 06
SELECT CASE WHEN exists (SELECT * FROM ltdb.onetime_auth r
WHERE r.user_id=${userId} and r.uuid_part = ${uuid} and 
expires_on > current_timestamp()) THEN true ELSE false END AS 'exists';

# ========= Query 07
INSERT INTO ltdb.users
( login, passwd, first_name, last_name, middle_name, gender,
is_external, email )
VALUES ( ${login}, ${password}, ${firstName}, ${lastName}, ${middleName},
${gender}, ${external}, ${email} );

# ========= Query 08
UPDATE ltdb.users
SET
login = ${login}, passwd = ${password},
first_name = ${firstName},last_name = ${lastName}, gender = ${gender},
verified = ${verified}
WHERE user_id=${userId}

# ========= Query 09
UPDATE ltdb.users
SET last_login = CURRENT_TIMESTAMP(), failed_logins = ${failedLogins}
WHERE user_id=${userId}

# ========= Query 10
SELECT u.* FROM ltdb.users u
WHERE u.user_id=${userId};

# ========= Query 11
SELECT u.* FROM ltdb.users u
WHERE u.login=${login}

# ========= Query 12
SELECT u.* FROM ltdb.users u    
WHERE u.email=${email}

# ========= Query 13
INSERT INTO ltdb.audit_logs
(app_user,activity, client_ip)
VALUES(${appUser}, ${activity}, ${clientIp});

# ========= Query 14
INSERT INTO ltdb.content
(content_type,url,title,user_id,is_private,description,tags)
VALUES(${contentType}, ${url}, ${title}, ${userId}, ${isPrivate},
${description},${tags});

# ========= Query 15
UPDATE ltdb.content
SET content_type=${contentType},url=${url},title=${title}, tags=${tags},
user_id=${userId},is_private=${isPrivate},description=${description}
WHERE content_id=${contentId} AND user_id=${userId};

# ========= Query 16
DELETE FROM ltdb.content WHERE content_id=${contentId} AND user_id=${userId};

# ========= Query 17
select * from ltdb.content c where c.user_id=${userId}
    AND c.title LIKE CONCAT('%', ${q}, '%')

# ========= Query 18
INSERT INTO ltdb.subscriptions (user_id, trail_id)
VALUES (${userId}, ${trailId});

# ========= Query 19
DELETE FROM ltdb.subscriptions WHERE subsc_id=${subsId} AND user_id=${userId};

# ========= Query 20
select s.subsc_id, t.* from ltdb.subscriptions s
join 
(select max(i.item_id) as item_id, i.url, t.* from ltdb.trails t
join
(select c.url, ii.item_id, ii.trail_id, c.content_type
from ltdb.trail_items ii
left join ltdb.content c on c.content_id=ii.content_id
) as i on i.trail_id = t.trail_id AND i.content_type='V'
group by t.trail_id)
t on t.trail_id=s.trail_id
where s.user_id=${userId}

# ========= Query 21
select count(*) count from ltdb.comments c
where c.item_id in (
select ti.item_id from ltdb.trail_items ti where ti.trail_id=${trailId});

# ========= Query 22
SELECT count(*) count FROM ltdb.analytics a
WHERE a.trail_id=${trailId} and action = 'VT';

# ========= Query 23
select count(*) count from ltdb.subscriptions s
where s.trail_id=${trailId};

# ========= Query 24
INSERT INTO ltdb.trails(title,is_private,user_id,tags)
VALUES(${title}, ${isPrivate}, ${createdBy}, ${tags});

# ========= Query 25
UPDATE ltdb.trails
SET title = ${title}, is_private = ${isPrivate}, tags=${tags}
WHERE trail_id=${trailId}

# ========= Query 26
DELETE FROM ltdb.trails WHERE trail_id=${trailId} AND user_id=${createdBy}

# ========= Query 27
select t.* from         (select max(i.item_id) as item_id, i.url, t.* from ltdb.trails t
join
(select c.url, ii.item_id, ii.trail_id, c.content_type
from ltdb.trail_items ii
left join ltdb.content c on c.content_id=ii.content_id
) as i on i.trail_id = t.trail_id AND i.content_type='V'
group by t.trail_id)
 t where t.user_id=${createdBy}

# ========= Query 28
select t.* from 
(select max(i.item_id) as item_id, i.url, t.* from ltdb.trails t
join
(select c.url, ii.item_id, ii.trail_id, c.content_type
from ltdb.trail_items ii
left join ltdb.content c on c.content_id=ii.content_id
) as i on i.trail_id = t.trail_id AND i.content_type='V'
group by t.trail_id)
t where t.is_private=0
LIMIT ${offset},${rows}

# ========= Query 29
select count(*) from 
(select max(i.item_id) as item_id, i.url, t.* from ltdb.trails t
join
(select c.url, ii.item_id, ii.trail_id, c.content_type
from ltdb.trail_items ii
left join ltdb.content c on c.content_id=ii.content_id
) as i on i.trail_id = t.trail_id AND i.content_type='V'
group by t.trail_id)
t where t.is_private=0

# ========= Query 30
select * from         (select max(i.item_id) as item_id, i.url, t.* from ltdb.trails t
join
(select c.url, ii.item_id, ii.trail_id, c.content_type
from ltdb.trail_items ii
left join ltdb.content c on c.content_id=ii.content_id
) as i on i.trail_id = t.trail_id AND i.content_type='V'
group by t.trail_id)
as aa
where aa.trail_id in
(
select distinct ti.trail_id from ltdb.trail_items ti
where ti.content_id in
(
select c.content_id from ltdb.content c
WHERE MATCH (c.title, c.description, c.tags)
AGAINST (${kw} IN BOOLEAN MODE)
) UNION
SELECT t.trail_id FROM ltdb.trails t
WHERE MATCH (t.title, t.tags)
AGAINST (${kw} IN BOOLEAN MODE)
);

# ========= Query 31
INSERT INTO ltdb.trail_items(trail_id, content_id, seq_no)
VALUES(${trailId}, ${content.contentId}, ${seqNo});

# ========= Query 32
UPDATE ltdb.trail_items SET seq_no=${seqNo} WHERE item_id=${itemId}

# ========= Query 33
DELETE FROM ltdb.trail_items WHERE item_id=${itemId}

# ========= Query 34
select * from ltdb.trail_items t
join ltdb.content v on v.content_id=t.content_id
where t.trail_id=${trailId} AND v.content_type='V'
order by t.seq_no

# ========= Query 35
select * from ltdb.trail_items t
join ltdb.content v on v.content_id=t.content_id
where t.trail_id=${trailId} AND v.content_type='R'

# ========= Query 36
select t.* from 
(select max(i.item_id) as item_id, i.url, t.* from ltdb.trails t
join
(select c.url, ii.item_id, ii.trail_id, c.content_type
from ltdb.trail_items ii
left join ltdb.content c on c.content_id=ii.content_id
) as i on i.trail_id = t.trail_id AND i.content_type='V'
group by t.trail_id) t
where t.trail_id=${trailId} and t.user_id=${createdBy}

# ========= Query 37
select t.* from         (select max(i.item_id) as item_id, i.url, t.* from ltdb.trails t
join
(select c.url, ii.item_id, ii.trail_id, c.content_type
from ltdb.trail_items ii
left join ltdb.content c on c.content_id=ii.content_id
) as i on i.trail_id = t.trail_id AND i.content_type='V'
group by t.trail_id) t
where t.trail_id=${trailId}

# ========= Query 38
INSERT INTO ltdb.comments
(author, comment, in_reply_to,item_id, level, subject, tags)
VALUES (${author}, ${comment}, ${inReplyTo}, ${trailItemId},
${level}, ${subject}, ${tags});

# ========= Query 39
UPDATE ltdb.comments
SET  comment = ${comment}, subject=${subject}, tags=${tags}
WHERE comment_id = ${commentId} and author=${author};

# ========= Query 40
DELETE FROM ltdb.comments
WHERE comment_id = ${commentId} and author=${author};

# ========= Query 41
SELECT c.*, CONCAT(u.first_name, ' ', u.last_name) author_name
FROM ltdb.comments c
JOIN ltdb.users u on u.user_id=c.author
WHERE c.item_id=${trailItemId}
order by level asc, upd_ts desc;

# ========= Query 42
SELECT c.*, CONCAT(u.first_name, ' ', u.last_name) author_name
FROM ltdb.comments c
JOIN ltdb.users u on u.user_id=c.author
where
        CONCAT(c.subject, ' ', c.comment) LIKE CONCAT('%', ${query}, '%')
        AND c.level=0 AND
        c.comment_id NOT IN 
        (SELECT DISTINCT in_reply_to FROM
        ltdb.comments WHERE in_reply_to IS NOT NULL
        AND trail_id=${trailId}
        )
        AND c.trail_id=${trailId}
        AND c.ins_ts >= ${postedAfter}
        AND c.ins_ts <= ${postedBefore}
order by level asc, upd_ts desc;

# ========= Query 43
SELECT * FROM ltdb.questions q
WHERE author=${author} AND
CONCAT(q.title, ' ', q.question) LIKE CONCAT('%', ${query}, '%')

# ========= Query 44
SELECT * FROM ltdb.questions where author=${author};

# ========= Query 45
SELECT * FROM ltdb.questions where question_id=${questionId};

# ========= Query 46
SELECT * FROM ltdb.answer_options where question_id=${value};

# ========= Query 47
SELECT * FROM ltdb.answer_options where question_id=${value};

# ========= Query 48
INSERT INTO ltdb.questions(type, question, feedback, author, title)
VALUES (${type}, ${question}, ${feedback}, ${author}, ${title});

# ========= Query 49
UPDATE ltdb.questions
SET  type = ${type}, question=${question}, feedback=${feedback}, title=${title}
WHERE question_id = ${questionId} and author=${author};

# ========= Query 50
DELETE FROM ltdb.answer_options
WHERE question_id = ${questionId};

# ========= Query 51
DELETE FROM ltdb.questions
WHERE question_id = ${questionId} and author=${author};

# ========= Query 52
INSERT INTO ltdb.answer_options(question_id, answer, author, is_correct)
VALUES (${questionId}, ${answer}, ${author}, ${correct});

# ========= Query 53
UPDATE ltdb.answer_options
SET question_id=${questionId}, answer=${answer}, author=${author},
is_correct=${correct}
WHERE ans_opt_id = ${answerOptId} and author=${author};

# ========= Query 54
DELETE FROM ltdb.answer_options
WHERE ans_opt_id = ${answerOptId} and author=${author};

# ========= Query 55
INSERT INTO ltdb.assessment_questions(assessment_id, question_id, points)
VALUES (${assessId}, ${questionId}, ${points});

# ========= Query 56
UPDATE ltdb.assessment_questions
SET assessment_id=${assessId}, question_id=${questionId}, points=${points}
WHERE assess_question_id = ${assessQuestId};

# ========= Query 57
DELETE FROM ltdb.assessment_questions
WHERE assess_question_id = ${assessQuestId};

# ========= Query 58
INSERT INTO ltdb.assessments(title,description, author,
wrong_ans_points,correct_ans_points,randomize_questions,randomize_answers,
allotted_minutes, show_score, open_time, close_time, is_published)
VALUES(${title}, ${description}, ${author}, ${wrongAnsPoints},
${correctAnsPoints}, ${randomizeQuestions}, ${randomizeAnswers},
${allottedMinutes}, ${showScore}, ${openTime}, ${closeTime}, ${published}
);

# ========= Query 59
UPDATE ltdb.assessments
SET title=${title}, description=${description}, author=${author},
wrong_ans_points=${wrongAnsPoints}, correct_ans_points=${correctAnsPoints},
randomize_questions=${randomizeQuestions},randomize_answers=${randomizeAnswers},
allotted_minutes=${allottedMinutes}, show_score=${showScore},
open_time=${openTime}, close_time=${closeTime}, is_published=${published}
WHERE assessment_id=${assessId};

# ========= Query 60
DELETE FROM ltdb.assessment_questions
WHERE assessment_id=${assessId};
DELETE FROM ltdb.assessments
WHERE assessment_id=${assessId};

# ========= Query 61
INSERT INTO ltdb.trail_assessments(trail_id, assessment_id)
VALUES(${trailId}, ${assessId});

# ========= Query 62
select a.*, t.trail_id from ltdb.trails t
join ltdb.trail_assessments ta on ta.trail_id=t.trail_id
join ltdb.assessments a on a.assessment_id=ta.assessment_id
where t.trail_id=${tid}

# ========= Query 63
DELETE FROM ltdb.trail_assessments
WHERE trail_assess_id=${trailAssessId};

# ========= Query 64
SELECT * FROM ltdb.assessments a
WHERE a.author=${author} AND a.title LIKE CONCAT('%', ${query}, '%');

# ========= Query 65
SELECT * FROM ltdb.assessments a WHERE a.assessment_id=${assessId}

# ========= Query 66
SELECT * FROM ltdb.assessments a WHERE a.assessment_id=${assessId}

# ========= Query 67
SELECT * FROM ltdb.assessments a WHERE a.author=${author}

# ========= Query 68
select s.*, a.*, CONCAT(u.first_name, ' ', u.last_name) student_name
from ltdb.assessment_submissions s
join ltdb.users u on u.user_id=s.student
join ltdb.assessments a on a.assessment_id=s.assessment_id
where s.student=${student}

# ========= Query 69
select s.*, a.*, CONCAT(u.first_name, ' ', u.last_name) student_name
from ltdb.assessment_submissions s
join ltdb.users u on u.user_id=s.student
join ltdb.assessments a on a.assessment_id=s.assessment_id
where s.assessment_id=${assessId}

# ========= Query 70
SELECT * FROM ltdb.assessment_questions aq
JOIN ltdb.questions q on q.question_id=aq.question_id
WHERE aq.assessment_id=${assessId}

# ========= Query 71
select * from ltdb.assessment_submissions s
join ltdb.assessments a on a.assessment_id=s.assessment_id
where s.submission_id=${submissionId}

# ========= Query 72
select * from ltdb.submission_responses r
where r.submission_id=${submissionId}

# ========= Query 73
INSERT INTO ltdb.assessment_submissions(student, assessment_id, is_draft)
VALUES(${student}, ${assessId}, ${draft});

# ========= Query 74
UPDATE ltdb.assessment_submissions
SET is_draft=${draft}, submitted_on=CURRENT_TIMESTAMP()
WHERE submission_id=${submissionId} AND student=${student} AND is_draft=1;

# ========= Query 75
DELETE FROM ltdb.submission_responses
WHERE submission_id=${submissionId};

# ========= Query 76
DELETE FROM ltdb.assessment_submissions
WHERE submission_id=${submissionId} AND student=${student} AND is_draft=1;

# ========= Query 77
INSERT INTO ltdb.submission_responses(submission_id,
assess_question_id, ans_opt_id, response)
VALUES(${submissionId}, ${assessQuestId}, ${answerOptId}, ${response});

# ========= Query 78
UPDATE ltdb.submission_responses
SET assess_question_id=${assessQuestId},
ans_opt_id=${answerOptId}, response=${response}
WHERE response_id=${responseId};

# ========= Query 79
DELETE FROM ltdb.submission_responses
WHERE response_id=${responseId};

# ========= Query 80
DELETE FROM ltdb.submission_responses
WHERE submission_id=${submissionId};


