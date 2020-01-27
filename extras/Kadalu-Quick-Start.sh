#!/bin/bash
#NOT A GENERIC SCRIPT!
#Deploy Kadalu Operator
echo -e "Do you want to deploy Kadalu or is it already deployed [y/n]"
read answer1
if [ $answer1 == 'y' ] ; then 

       kubectl create -f https://kadalu.io/operator-latest.yaml
       echo "Kadalu Operator Deplyoed"

else
#Create Storage Pool to the device, for future claims of this device
#Using kadalu kubectl plugin
        echo -e "Do you want to create a Storage-Pool [y/n]"
        read answer2

	if [ $answer2 == 'y' ] ; then 

		echo -e "Enter the storage-pool name"
		#example storage-pool-1
		read storagePool
		
		echo -e "Enter the device name"
		read device
		#if using Virtual Machine , minikube
                
                echo -e "Do you want to enter a path of device or Create a new Truncated file [path/create]"
                read answer3
                
                if [ $answer3 == "path" ] ; then

			echo -e "Enter the device file path"
			read devPath
			#example /home/vatsa/tryKadalu/disk/test-storage
                        kubectl kadalu storage-add $storagePool --device $device:$devPath
		        echo "Storage Pool with name $storagePool created"
                        
                else

		        echo -e "Enter the name of the device file to be created"
		        read dev
		        
		        echo -e "Enter the size of the truncated file in xG or xM"
		        read devSize

		        sudo truncate -s $devSize ${dev}
                        kubectl kadalu storage-add $storagePool --device $device:/home/vatsa/trykadalu/disk/$dev
		        echo "Storage Pool with name $storagePool created"
                
                fi
 
		
    
        else

	
		echo "Checking Status of the Pods"
		sudo kubectl get pods -n kadalu

		echo "Enter the name for the Pvc-File.yaml"
		read pvcFileName
		echo "Enter the name of the PVC"
		read pvcName
		echo "Enter the storage value in xGi or XMi , X is number"
		read storageValue

		cp /home/vatsa/experiment/samplePvc.yaml /home/vatsa/${pvcFileName}.yaml


		sed -i s/pv1/$pvcName/  /home/vatsa/${pvcFileName}.yaml 
		sed -i s/1Gi/$storageValue/  /home/vatsa/${pvcFileName}.yaml 

		sudo kubectl create -f /home/vatsa/${pvcFileName}.yaml

		kubectl get pvc

		echo "Enter the name of the app.yaml"
		read podFileName
		echo "Enter the name of the Pod"
		read podName

		cp /home/vatsa/experiment/sampleApp.yaml /home/vatsa/${podFileName}.yaml
		sed -i s/pod1/$podName/  /home/vatsa/${podFileName}.yaml
		sed -i s/pv1/$pvcName/  /home/vatsa/${podFileName}.yaml

		sudo kubectl create -f /home/vatsa/$podFileName.yaml
	fi
	    
fi
