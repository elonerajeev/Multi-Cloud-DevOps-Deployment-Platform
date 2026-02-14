// src/components/ErrorBoundary.js
import React, { Component } from 'react';
import './/ErrorBoundary.css' // Import the CSS for styling

class ErrorBoundary extends Component {
    constructor(props) {
        super(props);
        this.state = { hasError: false, errorMessage: '' };
    }

    static getDerivedStateFromError(error) {
        return { hasError: true, errorMessage: error.message };
    }

    componentDidCatch(error, errorInfo) {
        console.error("Error caught in Error Boundary: ", error, errorInfo);
    }

    render() {
        if (this.state.hasError) {
            return (
                <div className="error-container">
                    <h2>Something went wrong.</h2>
                    <p>{this.state.errorMessage}</p>
                    <button onClick={() => window.location.reload()} className="btn-reload">
                        Reload Page
                    </button>
                </div>
            );
        }

        return this.props.children;
    }
}

export default ErrorBoundary;
