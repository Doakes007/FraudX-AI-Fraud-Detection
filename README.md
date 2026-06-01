# FraudX – AI-Powered Fraud Detection in Digital Transactions

FraudX is a full-stack digital banking simulation platform with AI-powered fraud detection for financial transactions. The system combines machine learning, backend APIs, mobile application development, cloud deployment, and transaction monitoring to simulate fraud prevention in a banking environment.

---

## Key Highlights

* Trained on 6M+ PaySim transactions
* Achieved 93.9% Precision and 100% Recall
* Flutter mobile application
* Flask REST API backend
* PostgreSQL database integration
* JWT-based authentication
* Device verification workflow
* Dockerized deployment
* AWS EC2 cloud hosting
* Real Android device testing
* Admin analytics dashboard

---

## Overview

FraudX detects suspicious financial transactions using a Balanced Random Forest model trained on the PaySim dataset (~6 million transactions).

The system simulates a digital banking environment where users can transfer money, view transaction history, receive fraud alerts, and monitor risk levels while administrators can oversee platform-wide fraud activity.

### Features

* Real-time fraud prediction
* Fraud probability scoring
* Device verification checks
* Dynamic user risk levels
* Transaction history tracking
* Fraud alerts dashboard
* Admin analytics panel
* User/Admin role separation
* JWT authentication
* Cloud deployment on AWS

---

## System Architecture

<img width="552" height="732" alt="Architecture Diagram" src="https://github.com/user-attachments/assets/e8f04bac-d2e8-42e1-b4fa-9e83de9a0cf9" />

---

## Deployment Architecture

```text
Flutter Android App
         │
         ▼
AWS EC2 Instance
         │
         ▼
Docker Container
         │
         ▼
Flask REST APIs
         │
         ▼
PostgreSQL Database
         │
         ▼
Fraud Detection Engine
(Balanced Random Forest)
```

---

## Tech Stack

### Frontend

* Flutter
* Dart

### Backend

* Flask
* REST APIs
* JWT Authentication

### Machine Learning

* Balanced Random Forest
* Scikit-Learn
* Pandas
* NumPy
* Imbalanced-Learn

### Database

* PostgreSQL

### Cloud & DevOps

* AWS EC2
* Docker
* Ubuntu Linux

### Tools

* Git
* GitHub

---

## Machine Learning Pipeline

### Dataset

* PaySim Dataset (~6M transactions)

### Feature Engineering

Implemented features include:

* Transaction type encoding
* Amount-to-balance ratio
* Device transaction statistics
* User behavioral averages
* Night transaction indicator
* Device verification checks
* Distance-from-home estimation
* High-risk transaction indicators

### Model

```python
BalancedRandomForestClassifier(
    n_estimators=300,
    max_depth=5,
    random_state=42
)
```

### Evaluation Metrics

| Metric    | Score |
| --------- | ----- |
| Precision | 93.9% |
| Recall    | 100%  |

---

## Security Features

* JWT-based Authentication
* User/Admin Role Separation
* Device Verification Checks
* Fraud Probability Scoring
* Transaction Monitoring
* Fraud Alert Generation

---

## API Endpoints

### Authentication

#### Login

```http
POST /api/auth/login
```

Request

```json
{
  "email": "user@example.com",
  "password": "password"
}
```

Response

```json
{
  "token": "jwt_token"
}
```

---

### Transfer Money

```http
POST /api/transaction/transfer
```

Request

```json
{
  "sender": 1,
  "receiver": 2,
  "amount": 5000,
  "device_id": "abc123"
}
```

Response

```json
{
  "is_fraud": 0,
  "fraud_probability": 0.12
}
```

---

### Transaction History

```http
GET /api/transaction/history/<user_id>
```

---

### Fraud Transactions

```http
GET /api/transaction/fraud/<user_id>
```

---

### Admin Statistics

```http
GET /api/admin/stats
```

---

## Database Schema

### Users

* user_id
* name
* email
* password
* risk_level
* is_admin

### Accounts

* account_id
* user_id
* balance

### Transactions

* sender_id
* receiver_id
* amount
* fraud_flag
* fraud_probability
* timestamp

### User Devices

* device_id
* user_id

---

## Screenshots

### User Features

* Login Screen
* Dashboard
* Send Money
* Transaction History
* Fraud Alerts

### Admin Features

* Admin Dashboard
* System Statistics
* User Management
* Fraud Monitoring

> Add screenshots here

---

## End-to-End Testing

FraudX was tested using:

* Flutter Android Application
* AWS-hosted Backend
* PostgreSQL Database
* Dockerized Deployment
* Real Internet Connectivity

### Verified Workflows

* User Login
* Money Transfer
* Fraud Prediction
* Transaction History
* Fraud Alerts
* Admin Dashboard
* JWT Authentication
* Device Verification

---

## How To Run

### Clone Repository

```bash
git clone https://github.com/yourusername/FraudX.git
```

---

### Backend Setup

```bash
cd backend

pip install -r requirements.txt

python app.py
```

---

### Frontend Setup

```bash
cd fraudx_app

flutter pub get

flutter run
```

---

### Docker Deployment

Build Image

```bash
docker build -t fraudx-backend .
```

Run Container

```bash
docker run -d -p 5000:5000 fraudx-backend
```

---

## Results

* Precision: 93.9%
* Recall: 100%
* Fraud Probability Scoring
* Dynamic Risk Level Updates
* Device Verification Workflow
* Cloud Deployment Validation
* Mobile-to-Cloud Communication Verified

---

## Future Improvements

* Redis Caching
* CI/CD Pipeline
* Explainable AI (XAI)
* Multi-Factor Authentication
* Real-Time Streaming Fraud Detection
* Kubernetes Deployment

---

## Contributors

* Chirag N
* Rhiya Giridhara Bhat
* Ghanashyam D
* Tarun GP

---

## License

This project was developed for academic and educational purposes.
