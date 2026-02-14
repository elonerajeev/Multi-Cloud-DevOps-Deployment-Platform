# 🚀 MERN E-Commerce App Deployment Pipeline

[![CI/CD Pipeline for MERN App](https://github.com/elonerajeev/E-Commerce-App-Deployment-Pipeline-/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/elonerajeev/E-Commerce-App-Deployment-Pipeline-/actions/workflows/ci-cd.yml)

Welcome to the **CI/CD Pipeline for a MERN E-Commerce Application**! This repository demonstrates a complete DevOps workflow using Docker, GitHub Actions, and Render for deploying a full-stack MERN (MongoDB, Express, React, Node.js) app.

![alt text](image8.png)

---

## 📦 Project Structure

```bash
📦E-Commerce-App-Deployment-Pipeline-
├── backend/                         # Express.js backend
│   ├── config/                      # Configuration files (DB, env, etc.)
│   ├── controllers/                 # Route controllers
│   ├── middleware/                  # Express middleware
│   ├── models/                      # Mongoose models
│   ├── routes/                      # Express routes
│   ├── utils/                       # Utility functions
│   ├── .env.example                 # Example environment variables
│   ├── Dockerfile                   # Backend Dockerfile
│   ├── package.json
│   └── server.js                    # Entry point
├── frontend/                        # React.js frontend
│   ├── public/
│   ├── src/
│   │   ├── assets/                  # Images and static assets
│   │   ├── components/              # React components
│   │   ├── pages/                   # React pages
│   │   ├── redux/                   # Redux store, slices, actions
│   │   ├── utils/                   # Utility functions
│   │   ├── App.js
│   │   └── index.js
│   ├── .env.example                 # Example frontend env variables
│   ├── Dockerfile                   # Frontend Dockerfile
│   └── package.json
├── .github/
│   └── workflows/
│       └── ci-cd.yml                # GitHub Actions workflow
├── .gitignore
├── docker-compose.yml               # Docker Compose for local dev
└── README.md
```

---

## 📌 What This Pipeline Does

✅ Automatically builds both frontend and backend Docker images<br>
✅ Pushes images to Docker Hub<br>
✅ Triggers Render deployments using deploy hooks<br>
✅ Skips manual approval for fully automated deployment<br>
✅ Uses GitHub Actions for CI/CD pipeline

---

## 🛠️ Technologies Used

* ⚙️ **GitHub Actions** – CI/CD automation
* 🐳 **Docker** – Containerization
* ☁️ **Render** – Cloud deployment
* 💾 **MongoDB Atlas** – Cloud database
* 🌐 **Node.js & Express.js** – Backend
* 🧠 **React.js** – Frontend

---

## 🌐 Live Demo Links

* 🔗 **Frontend**: [Live Frontend on Render](https://e-commerce-app-deployment-pipeline.onrender.com)
* 🔗 **Backend API**: [Live Backend on Render](https://e-commerce-app-deployment-pipeline-1.onrender.com)


---

## 🚦 CI/CD Pipeline Flow Diagram

![alt text](image.png)
![alt text](image1.png)



### 🔁 Workflow Stages

1. **Push to main branch**
2. ✅ CI: Install, Lint, and Build code
3. 🛠️ Docker Build for Frontend & Backend
4. 📦 Push Docker Images to Docker Hub
5. 🚀 Trigger Deploy Hooks on Render


> 💡 Want to try it yourself? Fork this repo and set your own Docker & Render secrets!

---

## 🔐 Secrets Configuration (GitHub → Settings → Secrets → Actions)

| Secret Name                   | Description                      |
| ----------------------------- | -------------------------------- |
| `DOCKER_USERNAME`             | Your Docker Hub username         |
| `DOCKER_PASSWORD`             | Docker Hub access token/password |
| `RENDER_DEPLOY_HOOK_FRONTEND` | Render deploy hook for frontend  |
| `RENDER_DEPLOY_HOOK_BACKEND`  | Render deploy hook for backend   |

---

## ✅ Workflow Badge

Display this badge in your repo to show the pipeline status:

[![CI/CD Pipeline for MERN App](https://github.com/elonerajeev/E-Commerce-App-Deployment-Pipeline-/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/elonerajeev/E-Commerce-App-Deployment-Pipeline-/actions/workflows/ci-cd.yml)
---

## 📸 Screenshots

### ✅ GitHub Actions Pipeline Passed

![alt text](image.png)
[![CI/CD Pipeline for MERN App](https://github.com/elonerajeev/E-Commerce-App-Deployment-Pipeline-/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/elonerajeev/E-Commerce-App-Deployment-Pipeline-/actions/workflows/ci-cd.yml)

### 🖥️ Live Frontend on Render

* 🔗 **Frontend**: [Live Frontend on Render](https://e-commerce-app-deployment-pipeline.onrender.com)

![alt text](image4.png)

![alt text](image5.png)

![alt text](image6.png)

### 🧠 Backend API Connected to MongoDB

![alt text](image7.png)
---

## 🤝 Author

Made with ❤️ by **[Rajeev Kumar (Elone Rajeev)](https://github.com/elonerajeev)**

* 📧 Email: [rajeevkumarx12@gmail.com](mailto:rajeevkumarx12@gmail.com)
* 💼 [LinkedIn](https://linkedin.com/in/rajeev-kumar-2209b1243)
* 🧑‍💻 [GitHub](https://github.com/elonerajeev)
* 🌐 [Portfolio](https://rajeevxportfolio.netlify.app)

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).

> 🔄 Always feel free to contribute or suggest improvements!
