## 1
Since uphold publishes their official docker container on docker hub, I needed an idea what else (non-trivial) can I do

So I decided to build an alpine based image 

At the end tho, turns out resources are out there on how to do it as alpine is missing some libraries to run the litecoin binaries (comments in the dockerfile) 

```bash
buildanddeploy.bash
```

It does: 
 - build the dockerfile
 - scan the docker image with anchore/grype
 - run the image on demand

Requires:
 - bash
 - docker
 - curl

## 2

It does: 
 - create the ns
 - create the statefulset

Requires:
 - k8s cluster
 - kubectl

```bash
kubectl create namespace litecoinfarm
kubectl apply -f litecoin_statefulset.yaml
```

## 3
I apologise if the below sounds rejective towards the assignment, I might not understand the task, forgive me.

The pipelines I worked with (Teamcity and AzDo) were built to mainly
 
 - build java/scala project with maven/gradle
 - store binaries in an artifact store
 - build docker image, push it to a container registry
 - pull version-matching helm-charts stored in git repo
 - deploy kubernetes resources to all environments (qa/uat/prod) (later Azure DevTestLabs were integrated into Build pipelines to run automated and functional tests)
 - even run some automated health checks, warming cache 
 - etc...

At present task I have difficulty making sense to work with an adhoc jenkins/gitlab env
Since I guess I would not be able to do anything like the above 
Other than dissecting my former bash scripts to build the docker image / scan / deploy to k8s in different steps, maybe adding some more steps.


## 4 & 5

I like to do coding challenges every now and then, I hope this text manipulation-like I solved a while ago in Python will do for the task: [Coderbyte - MinWindowSubstring](https://coderbyte.com/results/peettong:Min%20Window%20Substring:Python3)
I do have challenge solutions on [codewars](https://www.codewars.com/users/blacklotus) and [hackerrank](https://www.hackerrank.com/peettong?hr_r=1) as well, but text manipulation related ones are all easy challenges

## 6

Since I was working with Azure, I looked up what would be the equivalent to role 'assumption' in Azure AD:

Roles in the sense of IAM Roles that can be assumed by a VM or similar don’t really exist in Azure. 
What Azure does have is the concept of applications and service principals. 
Applications are a way to register an application to get access to your identities. 
These can be both applications you have developed your self and off the shelf applications which are built to work with AAD (Office 365, Salesforce etc.). 
A service principal is an identity assigned to these applications, that will be used by a specific application (or set of applications) to assume and gain access to Azure resources. 
An application would use the service principal by supplying either a set of keys or a certificate.

source: https://samcogan.com/azure-for-the-aws-user-part-1-identity/

However AD is one of the areas in IT that I never touched so I`d opt for another assignment anything else than AD
