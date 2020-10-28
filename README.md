### Automated Deployments

#### Description:
*A Java based project is configured in a Jenkins job to automatically deploy to a Dockerized Environment.*


- To create a custom application, build the "helloworld-project" folder by maven (or "hometask" folder). You can build also "simple-sample" folder by gradle.
The folders already contain all the necessary files.
- To create a tomkat image with a custom application, use the "docker" folder.
- To deploy the infrastructure with tomkat, use "Deployment.yaml" and "Ingress-helloworld.yaml" files in the root directory.


https://helloworld-izaitsava.k8s.izaitsava.playpit.by/
![1](https://github.com/MNT-Lab/build-t00ls/blob/izaitsava/screenshots/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%20%D0%BE%D1%82%202020-10-29%2000-16-00.png)
![2](https://github.com/MNT-Lab/build-t00ls/blob/izaitsava/screenshots/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%20%D0%BE%D1%82%202020-10-29%2000-16-03.png)
http://jenkins.k8s.izaitsava.playpit.by/
![3](https://github.com/MNT-Lab/build-t00ls/blob/izaitsava/screenshots/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%20%D0%BE%D1%82%202020-10-29%2001-04-23.png)
https://nexus.k8s.izaitsava.playpit.by/
![4](https://github.com/MNT-Lab/build-t00ls/blob/izaitsava/screenshots/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%20%D0%BE%D1%82%202020-10-29%2001-04-07.png)
http://sonar.k8s.izaitsava.playpit.by/
![5](https://github.com/MNT-Lab/build-t00ls/blob/izaitsava/screenshots/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%20%D0%BE%D1%82%202020-10-29%2001-07-38.png)

