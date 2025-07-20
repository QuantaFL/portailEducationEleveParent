
# Backend Data Model Documentation

This document outlines the data models used in the application. It is intended to guide backend developers in structuring the data they send to the application.

## ClassModel

**File:** `lib/app/core/data/models/class_model.dart`

| Field          | Type     | Description              |
|----------------|----------|--------------------------|
| `id`           | `int`    | The unique identifier for the class. |
| `name`         | `String` | The name of the class.     |
| `academicYear` | `String` | The academic year of the class. |
| `createdAt`    | `String?`| The timestamp when the class was created. |
| `updatedAt`    | `String?`| The timestamp when the class was last updated. |

**JSON Example:**

```json
{
  "id": 1,
  "name": "6eme",
  "academicYear": "2024-2025",
  "createdAt": "2024-07-13T10:00:00Z",
  "updatedAt": "2024-07-13T10:00:00Z"
}
```

---

## LoginRequest

**File:** `lib/app/core/data/models/login_request.dart`

| Field      | Type     | Description              |
|------------|----------|--------------------------|
| `email`    | `String` | The user's email address. |
| `password` | `String` | The user's password.     |

**JSON Example:**

```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

---

## NotificationModel

**File:** `lib/app/core/data/models/notification_model.dart`

| Field       | Type       | Description              |
|-------------|------------|--------------------------|
| `id`        | `int`      | The unique identifier for the notification. |
| `userId`    | `int`      | The ID of the user who received the notification. |
| `type`      | `String`   | The type of notification. |
| `message`   | `String`   | The content of the notification. |
| `isSent`    | `bool`     | Whether the notification has been sent. |
| `sentAt`    | `String?`  | The timestamp when the notification was sent. |
| `createdAt` | `String?`  | The timestamp when the notification was created. |
| `updatedAt` | `String?`  | The timestamp when the notification was last updated. |
| `isRead`    | `bool?`    | Whether the notification has been read. |
| `readAt`    | `DateTime?`| The timestamp when the notification was read. |

**JSON Example:**

```json
{
  "id": 1,
  "userId": 123,
  "type": "info",
  "message": "Your grades have been updated.",
  "isSent": true,
  "sentAt": "2024-07-13T10:00:00Z",
  "createdAt": "2024-07-13T09:55:00Z",
  "updatedAt": "2024-07-13T10:05:00Z",
  "isRead": false,
  "readAt": null
}
```

---

## ReportCard

**File:** `lib/app/core/data/models/report_card.dart`

| Field                 | Type     | Description              |
|-----------------------|----------|--------------------------|
| `id`                  | `int`    | The unique identifier for the report card. |
| `studentId`           | `int`    | The ID of the student.     |
| `academicYear`        | `String` | The academic year of the report card. |
| `period`              | `String` | The period of the report card (e.g., "1st Trimester"). |
| `averageGradeGeneral` | `double?`| The student's general average grade. |
| `mention`             | `String?`| The mention received by the student. |
| `rank`                | `int?`   | The student's rank in the class. |
| `appreciation`        | `String?`| The teacher's appreciation. |
| `pdfPath`             | `String` | The path to the PDF of the report card. |
| `generatedAt`         | `String` | The timestamp when the report card was generated. |
| `createdAt`           | `String?`| The timestamp when the report card was created. |
| `updatedAt`           | `String?`| The timestamp when the report card was last updated. |

**JSON Example:**

```json
{
  "id": 1,
  "studentId": 456,
  "academicYear": "2024-2025",
  "period": "1st Trimester",
  "averageGradeGeneral": 15.5,
  "mention": "Bien",
  "rank": 5,
  "appreciation": "Good work, keep it up!",
  "pdfPath": "/path/to/report_card.pdf",
  "generatedAt": "2024-07-13T10:00:00Z",
  "createdAt": "2024-07-13T09:55:00Z",
  "updatedAt": "2024-07-13T10:05:00Z"
}
```

---

## Role

**File:** `lib/app/core/data/models/role.dart`

| Field | Type     | Description              |
|-------|----------|--------------------------|
| `id`  | `int`    | The unique identifier for the role. |
| `name`| `String` | The name of the role (e.g., "student", "parent", "teacher"). |

**JSON Example:**

```json
{
  "id": 1,
  "name": "student"
}
```

---

## Session

**File:** `lib/app/core/data/models/session.dart`

| Field        | Type      | Description              |
|--------------|-----------|--------------------------|
| `id`         | `int?`    | The unique identifier for the session. |
| `session`    | `String`  | The name of the session.   |
| `startDate`  | `DateTime`| The start date of the session. |
| `reenrollDate`| `DateTime?`| The re-enrollment date for the session. |
| `endDate`    | `DateTime`| The end date of the session. |
| `active`     | `bool`    | Whether the session is active. |

**JSON Example:**

```json
{
  "id": 1,
  "session": "2024-2025",
  "startDate": "2024-09-01T00:00:00Z",
  "reenrollDate": "2024-08-15T00:00:00Z",
  "endDate": "2025-06-30T23:59:59Z",
  "active": true
}
```

---

## Student

**File:** `lib/app/core/data/models/student.dart`

| Field             | Type         | Description              |
|-------------------|--------------|--------------------------|
| `id`              | `int`        | The unique identifier for the student. |
| `userId`          | `int`        | The ID of the user associated with the student. |
| `enrollmentDate`  | `String`     | The date the student was enrolled. |
| `classId`         | `int`        | The ID of the class the student is in. |
| `parentUserId`    | `int?`       | The ID of the user associated with the parent. |
| `studentIdNumber` | `String`     | The student's ID number. |
| `user`            | `User?`      | The user object associated with the student. |
| `classModel`      | `ClassModel?`| The class object the student is in. |
| `createdAt`       | `String?`    | The timestamp when the student was created. |
| `updatedAt`       | `String?`    | The timestamp when the student was last updated. |

**JSON Example:**

```json
{
  "id": 1,
  "userId": 123,
  "enrollmentDate": "2024-09-01",
  "classId": 1,
  "parentUserId": 456,
  "studentIdNumber": "S12345",
  "user": {
    "id": 123,
    "firstName": "John",
    "lastName": "Doe",
    "email": "john.doe@example.com",
    "phone": "123-456-7890",
    "password": "hashed_password",
    "roleId": 1,
    "address": "123 Main St",
    "dateOfBirth": "2010-01-01",
    "gender": "Male",
    "role": {
      "id": 1,
      "name": "student"
    },
    "rememberToken": null,
    "createdAt": "2024-07-13T10:00:00Z",
    "updatedAt": "2024-07-13T10:00:00Z"
  },
  "classModel": {
    "id": 1,
    "name": "6eme",
    "academicYear": "2024-2025",
    "createdAt": "2024-07-13T10:00:00Z",
    "updatedAt": "2024-07-13T10:00:00Z"
  },
  "createdAt": "2024-07-13T10:00:00Z",
  "updatedAt": "2024-07-13T10:00:00Z"
}
```

---

## StudentSession

**File:** `lib/app/core/data/models/student_session.dart`

| Field      | Type       | Description              |
|------------|------------|--------------------------|
| `id`       | `int?`     | The unique identifier for the student session. |
| `session`  | `Session`  | The session object.        |
| `student`  | `Student`  | The student object.        |
| `classe`   | `ClassModel`| The class object.          |
| `isLeave`  | `bool`     | Whether the student has left the session. |
| `isActive` | `bool`     | Whether the session is active for the student. |
| `enrollDate`| `DateTime` | The date the student was enrolled in the session. |
| `status`   | `String`   | The status of the student in the session. |

**JSON Example:**

```json
{
  "id": 1,
  "session": {
    "id": 1,
    "session": "2024-2025",
    "startDate": "2024-09-01T00:00:00Z",
    "reenrollDate": "2024-08-15T00:00:00Z",
    "endDate": "2025-06-30T23:59:59Z",
    "active": true
  },
  "student": {
    "id": 1,
    "userId": 123,
    "enrollmentDate": "2024-09-01",
    "classId": 1,
    "parentUserId": 456,
    "studentIdNumber": "S12345",
    "createdAt": "2024-07-13T10:00:00Z",
    "updatedAt": "2024-07-13T10:00:00Z"
  },
  "classe": {
    "id": 1,
    "name": "6eme",
    "academicYear": "2024-2025",
    "createdAt": "2024-07-13T10:00:00Z",
    "updatedAt": "2024-07-13T10:00:00Z"
  },
  "isLeave": false,
  "isActive": true,
  "enrollDate": "2024-09-01T00:00:00Z",
  "status": "enrolled"
}
```

---

## Subject

**File:** `lib/app/core/data/models/subject.dart`

| Field         | Type     | Description              |
|---------------|----------|--------------------------|
| `id`          | `int`    | The unique identifier for the subject. |
| `name`        | `String` | The name of the subject.   |
| `coefficient` | `double` | The coefficient of the subject. |
| `level`       | `String?`| The level of the subject.  |
| `createdAt`   | `String?`| The timestamp when the subject was created. |
| `updatedAt`   | `String?`| The timestamp when the subject was last updated. |

**JSON Example:**

```json
{
  "id": 1,
  "name": "Math",
  "coefficient": 2.5,
  "level": "Beginner",
  "createdAt": "2024-07-13T10:00:00Z",
  "updatedAt": "2024-07-13T10:00:00Z"
}
```

---

## Teacher

**File:** `lib/app/core/data/models/teacher.dart`

| Field       | Type      | Description              |
|-------------|-----------|--------------------------|
| `id`        | `int`     | The unique identifier for the teacher. |
| `userId`    | `int`     | The ID of the user associated with the teacher. |
| `hireDate`  | `String`  | The date the teacher was hired. |
| `user`      | `User?`   | The user object associated with the teacher. |
| `createdAt` | `String?` | The timestamp when the teacher was created. |
| `updatedAt` | `String?` | The timestamp when the teacher was last updated. |

**JSON Example:**

```json
{
  "id": 1,
  "userId": 789,
  "hireDate": "2020-09-01",
  "user": {
    "id": 789,
    "firstName": "Jane",
    "lastName": "Smith",
    "email": "jane.smith@example.com",
    "phone": "987-654-3210",
    "password": "hashed_password",
    "roleId": 2,
    "address": "456 Oak Ave",
    "dateOfBirth": "1985-05-20",
    "gender": "Female",
    "role": {
      "id": 2,
      "name": "teacher"
    },
    "rememberToken": null,
    "createdAt": "2024-07-13T10:00:00Z",
    "updatedAt": "2024-07-13T10:00:00Z"
  },
  "createdAt": "2024-07-13T10:00:00Z",
  "updatedAt": "2024-07-13T10:00:00Z"
}
```

---

## TeacherSubjectClass

**File:** `lib/app/core/data/models/teacher_subject_class.dart`

| Field       | Type      | Description              |
|-------------|-----------|--------------------------|
| `teacherId` | `int`     | The ID of the teacher.     |
| `subjectId` | `int`     | The ID of the subject.     |
| `classId`   | `int`     | The ID of the class.       |
| `createdAt` | `String?` | The timestamp when the record was created. |
| `updatedAt` | `String?` | The timestamp when the record was last updated. |

**JSON Example:**

```json
{
  "teacherId": 1,
  "subjectId": 1,
  "classId": 1,
  "createdAt": "2024-07-13T10:00:00Z",
  "updatedAt": "2024-07-13T10:00:00Z"
}
```

---

## User

**File:** `lib/app/core/data/models/user.dart`

| Field           | Type      | Description              |
|-----------------|-----------|--------------------------|
| `id`            | `int`     | The unique identifier for the user. |
| `firstName`     | `String`  | The user's first name.     |
| `lastName`      | `String`  | The user's last name.      |
| `email`         | `String`  | The user's email address. |
| `phone`         | `String`  | The user's phone number.   |
| `password`      | `String`  | The user's password.       |
| `address`       | `String`  | The user's address.        |
| `dateOfBirth`   | `String`  | The user's date of birth.  |
| `gender`        | `String`  | The user's gender.         |
| `roleId`        | `int`     | The ID of the user's role. |
| `role`          | `Role?`   | The user's role object.    |
| `rememberToken` | `String?` | The user's remember token. |
| `createdAt`     | `String?` | The timestamp when the user was created. |
| `updatedAt`     | `String?` | The timestamp when the user was last updated. |

**JSON Example:**

```json
{
  "id": 1,
  "firstName": "John",
  "lastName": "Doe",
  "email": "john.doe@example.com",
  "phone": "123-456-7890",
  "password": "hashed_password",
  "address": "123 Main St",
  "dateOfBirth": "2010-01-01",
  "gender": "Male",
  "roleId": 1,
  "role": {
    "id": 1,
    "name": "student"
  },
  "rememberToken": null,
  "createdAt": "2024-07-13T10:00:00Z",
  "updatedAt": "2024-07-13T10:00:00Z"
}
```
