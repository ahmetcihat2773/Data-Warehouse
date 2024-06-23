# Installation of Necessary Tools

To set up a local Kubernetes cluster, we need to install Minikube. We'll run everything inside this cluster. Follow these steps to start the installation process:

1. Open PowerShell as an administrator.
2. Navigate to the directory containing the `install_minikube.ps1` script.
3. Run the following command:

    ```sh
    ./install_minikube.ps1
    ```

If you are not in the same directory as the script, specify the full path to `install_minikube.ps1`. This script will install Chocolatey (a Windows package manager), Minikube, Docker Desktop, and kubectl.

Now you can use kubectl to communicate with your cluster. For example you can check the namespaces in your cluster with the following command. 

```sh
kubectl get ns
```
This will return all available namespaces in your cluster. 

