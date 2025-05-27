pipeline {
    agent any

    stages {
        stage  {
            steps {
                git 'https://https://github.com/amitbk02/myscript-repo.git'
            }
        }

        stage('Build') {
            steps {
                echo 'Build step (no actual build for HTML)'
            }
        }

        
    }
}
