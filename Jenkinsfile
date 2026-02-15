pipeline {
    agent any

    environment {
        AWS_REGION = "us-east-1"
        AWS_ACCOUNT_ID = credentials('aws-account-id')  // Add this in Jenkins: Manage Jenkins → Credentials → Secret text
        ECR_REGISTRY = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
        DOCKER_FRONTEND_IMAGE = "shop-app-frontend"
        DOCKER_BACKEND_IMAGE = "shop-app-backend"
        DOCKER_TAG = "${BUILD_NUMBER}"
    }

    triggers {
        githubPush()  // Trigger on GitHub push
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/elonerajeev/Multi-Cloud-DevOps-Deployment-Platform.git'
            }
        }

        stage('Build Images') {
            parallel {

                stage('Frontend Build') {
                    steps {
                        dir('app/frontend') {
                            sh '''
                            docker build -t $DOCKER_FRONTEND_IMAGE:$DOCKER_TAG -f Dockerfile.prod .
                            '''
                        }
                    }
                }

                stage('Backend Build') {
                    steps {
                        dir('app/backend') {
                            sh '''
                            docker build -t $DOCKER_BACKEND_IMAGE:$DOCKER_TAG -f Dockerfile.prod .
                            '''
                        }
                    }
                }
            }
        }

        stage('Security Scan (Trivy)') {
            steps {
                sh '''
                trivy image --exit-code 0 --severity HIGH,CRITICAL $DOCKER_BACKEND_IMAGE:$DOCKER_TAG || true
                trivy image --exit-code 0 --severity HIGH,CRITICAL $DOCKER_FRONTEND_IMAGE:$DOCKER_TAG || true
                '''
            }
        }

        stage('Push to AWS ECR') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-credentials'
                ]]) {
                    sh '''
                    aws ecr get-login-password --region $AWS_REGION | \
                    docker login --username AWS --password-stdin $ECR_REGISTRY

                    # Tag images for ECR
                    docker tag $DOCKER_BACKEND_IMAGE:$DOCKER_TAG $ECR_REGISTRY/$DOCKER_BACKEND_IMAGE:$DOCKER_TAG
                    docker tag $DOCKER_FRONTEND_IMAGE:$DOCKER_TAG $ECR_REGISTRY/$DOCKER_FRONTEND_IMAGE:$DOCKER_TAG
                    docker tag $DOCKER_BACKEND_IMAGE:$DOCKER_TAG $ECR_REGISTRY/$DOCKER_BACKEND_IMAGE:latest
                    docker tag $DOCKER_FRONTEND_IMAGE:$DOCKER_TAG $ECR_REGISTRY/$DOCKER_FRONTEND_IMAGE:latest

                    # Push images to ECR
                    docker push $ECR_REGISTRY/$DOCKER_BACKEND_IMAGE:$DOCKER_TAG
                    docker push $ECR_REGISTRY/$DOCKER_FRONTEND_IMAGE:$DOCKER_TAG
                    docker push $ECR_REGISTRY/$DOCKER_BACKEND_IMAGE:latest
                    docker push $ECR_REGISTRY/$DOCKER_FRONTEND_IMAGE:latest
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh '''
                    # Update image tags in deployments
                    sed -i "s|image: .*$DOCKER_FRONTEND_IMAGE:.*|image: $ECR_REGISTRY/$DOCKER_FRONTEND_IMAGE:$DOCKER_TAG|g" k8s/frontend/deployment.yaml
                    sed -i "s|image: .*$DOCKER_BACKEND_IMAGE:.*|image: $ECR_REGISTRY/$DOCKER_BACKEND_IMAGE:$DOCKER_TAG|g" k8s/backend/deployment.yaml
                    
                    # Apply Kubernetes manifests
                    kubectl apply -f k8s/namespace.yaml
                    kubectl apply -f k8s/configmap.yaml
                    kubectl apply -f k8s/secret.yaml
                    kubectl apply -f k8s/backend/
                    kubectl apply -f k8s/frontend/
                    kubectl apply -f k8s/ingress.yaml
                    
                    # Wait for rollout
                    kubectl rollout status deployment/backend -n shop --timeout=5m
                    kubectl rollout status deployment/frontend -n shop --timeout=5m
                    '''
                }
            }
        }

        stage('Health Check') {
            steps {
                script {
                    sh '''
                    echo "Waiting for rollout..."
                    kubectl rollout status deployment/backend -n shop --timeout=5m
                    kubectl rollout status deployment/frontend -n shop --timeout=5m
                    echo "Waiting for LoadBalancer..."
                    sleep 45
                    BACKEND_HOST=$(kubectl get svc backend -n shop -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' 2>/dev/null || true)
                    if [ -n "$BACKEND_HOST" ]; then
                      echo "Checking backend /health..."
                      curl -sf "http://$BACKEND_HOST:5000/health" || true
                    fi
                    kubectl get pods -n shop
                    kubectl get svc -n shop
                    '''
                }
            }
        }

        stage('Get Application URLs') {
            steps {
                script {
                    sh '''
                    echo "================================================"
                    echo "🌐 APPLICATION URLS"
                    echo "================================================"
                    
                    # Get Frontend URL
                    FRONTEND_URL=$(kubectl get svc frontend -n shop -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' 2>/dev/null || echo "Pending...")
                    echo "Frontend: http://$FRONTEND_URL"
                    
                    # Get Backend URL
                    BACKEND_URL=$(kubectl get svc backend -n shop -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' 2>/dev/null || echo "Pending...")
                    echo "Backend API: http://$BACKEND_URL:5000"
                    
                    echo "================================================"
                    echo ""
                    
                    # Save URLs to file for later reference
                    echo "FRONTEND_URL=http://$FRONTEND_URL" > deployment-urls.txt
                    echo "BACKEND_URL=http://$BACKEND_URL:5000" >> deployment-urls.txt
                    
                    # Display in Jenkins console
                    echo "✅ URLs saved to deployment-urls.txt"
                    '''
                }
            }
        }

        stage('Verify Monitoring') {
            steps {
                sh '''
                echo "================================================"
                echo "📊 MONITORING STATUS"
                echo "================================================"
                
                # Check Prometheus
                PROM_STATUS=$(kubectl get pods -n monitoring -l app.kubernetes.io/name=prometheus -o jsonpath='{.items[0].status.phase}' 2>/dev/null || echo "Not Found")
                echo "Prometheus: $PROM_STATUS"
                
                # Check Grafana
                GRAFANA_STATUS=$(kubectl get pods -n monitoring -l app.kubernetes.io/name=grafana -o jsonpath='{.items[0].status.phase}' 2>/dev/null || echo "Not Found")
                echo "Grafana: $GRAFANA_STATUS"
                
                # Get Grafana URL
                GRAFANA_URL=$(kubectl get svc -n monitoring monitoring-grafana -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' 2>/dev/null || echo "Pending...")
                echo "Grafana Dashboard: http://$GRAFANA_URL"
                echo "Default Login: admin / admin123"
                
                echo "================================================"
                '''
            }
        }
    }

    post {
        success {
            script {
                sh '''
                echo ""
                echo "╔════════════════════════════════════════════════╗"
                echo "║     ✅ DEPLOYMENT SUCCESSFUL!                  ║"
                echo "╚════════════════════════════════════════════════╝"
                echo ""
                echo "🌐 Access your application:"
                echo "   Frontend: http://$(kubectl get svc frontend -n shop -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')"
                echo "   Backend:  http://$(kubectl get svc backend -n shop -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'):5000"
                echo ""
                echo "📊 Monitoring Dashboard:"
                echo "   Grafana: http://$(kubectl get svc -n monitoring monitoring-grafana -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')"
                echo ""
                echo "⏰ Build #${BUILD_NUMBER} completed at $(date)"
                echo "================================================"
                '''
            }
        }
        failure {
            echo "❌ Pipeline Failed! Attempting rollback..."
            script {
                sh '''
                kubectl rollout undo deployment/backend -n shop --to-revision=0 2>/dev/null || true
                kubectl rollout undo deployment/frontend -n shop --to-revision=0 2>/dev/null || true
                echo "Recent events:"
                kubectl get events -n shop --sort-by=.lastTimestamp | tail -25
                '''
            }
        }
        always {
            sh 'docker system prune -f'
        }
    }
}
