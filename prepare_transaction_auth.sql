BEGIN;
PREPARE TRANSACTION '1333335';

INSERT INTO authentications (email, phone_number, login, password_digest, authentication_token)
VALUES ($1, $2, $3, $4, $5);

COMMIT PREPARED '1333335';