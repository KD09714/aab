// Change History										//
// 29-SEP-2018	Dharmendra Kumar	Initial Coding for Jenkins Pipeline to Build OVA.	//
// 30-SEP-2018  Dharmendra Kumar	Adding Delete VM call after Export completes.		//
// 01-OCT-2018	Dharmendra Kumar	Making changelog to false to avoid duplicate entry.    	//
// 04-OCT-2018	Dharmendra Kumar	Changes for 8.1 Sprint2					//
// 10-OCT-2018	Dharmendra Kumar	Added Email Notifications.				//
//////////////////////////////////////////////////////////////////////////////////////////////////

pipeline {
agent none
options { skipDefaultCheckout(true) }
	stages{
	stage ('General SCM'){
        	agent { label "master" }
            	steps {
			checkout changelog: false, scm: [$class: 'SubversionSCM', additionalCredentials: [], excludedCommitMessages: '', 
			excludedRegions: '', excludedRevprop: '', excludedUsers: '', filterChangelog: false, ignoreDirPropChanges: false, 
			includedRegions: '', locations: [[cancelProcessOnExternalsFail: true, credentialsId: 'smgrbuild', depthOption: 'infinity', 
			ignoreExternalsOption: true, local: '.', 
			remote: 'https://svn.forge.avaya.com/svnroot/smgrintegration/trunk/SMGR_R8.1/Sprint_2']], quietOperation: false, 
			workspaceUpdater: [$class: 'UpdateWithCleanUpdater']]

                        sh 'echo "BUILD_NUMBER=${BUILD_NUMBER}" > scripts/.build.number'
                        sh 'echo "BUILD_NUM=${BUILD_NUMBER}" >> scripts/.build.number'
    		}
	}
	stage ('Deploy Base OVA'){
		agent { label "master" }
		steps {
			dir ('scripts'){
				sh 'ant deploy.ova'
				sleep 180
			}
		}
	}
	stage ('SMGR Installation'){
		agent { label "master" }
		steps {
			dir ('scripts'){
				sh 'ant -f CopySMGR.xml'
				sh 'ant -f GetVersion.xml'
			}
		}
	}
	stage ('Adopters Installation'){
		agent { label "master" }
		steps {
			dir ('scripts'){
				sh 'ant -f CopyInstallIUScripts.xml'
			}
		}
	}
	stage ('Configure OVF'){
		agent { label "master" }
                steps {
                        dir ('scripts'){
                                sh 'ant -f Configure_ovf_file.xml -DBUILD_NUMBER=${BUILD_NUMBER}'
			}
		}
	}
	stage ('Pre Template'){
		agent { label "master" }
                steps {
                        dir ('scripts'){
                                sh 'ant -f PreTemplateCreation.xml'
			}
		}
	}
	stage ('Export and Delete VM'){
		agent { label "master" }
                steps {
                        dir ('scripts'){
				sh 'ant poweroff.vm export.ovf delete.vm'
			}
		}
	}
	stage ('Build OVA'){
		agent { label "master" }
                steps {
                        dir ('scripts'){
                                sh 'ant build.ova build.dev.ova'
                        }
                }
        }
	stage ('Publish OVA'){
		agent { label "master" }
                steps {
                        dir ('scripts'){
                                sh 'ant publish.ova publish.dev.ova'
                        }
                }
        }
	}
post {
success {
emailext body:
'''Build Number: ${BUILD_NUMBER}

Build Status: ${BUILD_STATUS}

OVA for Successful Build is available at:  http://10.129.154.158/SMGR/SMGR_Releases/R8.1_Sprint_2

Change History:

${CHANGES, showPaths=true}

~AuraPuneBuildTeam
''', recipientProviders: [developers()], subject: '$DEFAULT_SUBJECT', to: 'aurapunebuild@jenkins-ci.dr.avaya.com, punepanther@jenkins-ci.dr.avaya.com, smgraricent@jenkins-ci.dr.avaya.com'
        }
		
failure {
emailext body:
'''Build Number: ${BUILD_NUMBER}

Build Status: ${BUILD_STATUS}

Check console output at $BUILD_URL to view the results.

Change History:

${CHANGES, showPaths=true}

~AuraPuneBuildTeam
''', recipientProviders: [developers()], subject: '$DEFAULT_SUBJECT', to: 'aurapunebuild-test@jenkins-ci.dr.avaya.com'

	}
    }
}
