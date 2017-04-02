## Data challenge
The first goal of the challenge is to identify users with different IP addresses using multiple-devices.

For this, you will perform a supervised learning, based on classification.

The training dataset has n users, identified uniquely by their user IDs 1, 2 ... n. Based on the training data set, where the user IDs are provided, you have to recognize users and classify all remaining rows to a user IDs from 1 to n.

Every row in the dataset contains navigation data with data fields mentioned as in the following section. Once you train the data with your model, you can test it on the test dataset (Additional File DC2.csv) which contains all the data fields with 30% of undisclosed (noted as 0 zero in the User ID column) user IDs. You have to recognise the users and attribute to all the rows that have a missing user ID (coded with a zero value in the training dataset) a correct value of the user ID from 1 to n. Note that several rows can have the same user ID.

NB: In the dataset provided at the beginning of the Data Challenge, n=4. There are 4 users in the dataset. This dataset will be used to familiarise yourself with the datasets. Within one month from the beginning of the challenge, a dataset with a larger number of users will be disclosed. 

The second goal, once users have been identified, is to define a 24/7 behavioural profile of the users.

### Data Fields

The following data fields are available in the Additional File DC2.csv file. A brief description of all the fields are as follows:

ID Rows: a number is attributed to each row of the data set.  
URL: A unique address or reference (webpages - http) to a resource on the internet.  
From: The opening time of a web page (URL)   
Eg.: 18/02/2016 12:07:22 PM.  
To: The closing time of a web page (URL)   
Eg.: 18/02/2016 12:09:42 PM.  
IP: A numerical label assigned to each device participating in a computer network. This field contains both IPv4 and IPv6 formats.   
NB: Several users can share the same IP, and vice versa, same user can have several IP addresses  
Events: A JSON object that specifies the click events for the URL (in case the fields are blank, it means there was no click event that was registered for the specified timestamp).  
Media option: A JSON object specifying information about the URL containing a video (in case the fields are blank, it means the URL had no video embedded in it).   
Browser: The browser that is used to open a URL link. This field also contains information about the operating system in use.  
User ID: Each user is attributed a number from 1 to n. Number 0 (zero) represents a hidden User ID, the users that need to be identified by the students after applying the algorithm. Note that this column is not to be confused with the ID Rows column.  
