cloud_saver <- function(bucketname,df){ 

#Loading the libraries for Google Cloud and janitor====
  pacman::p_load(googleCloudStorageR, janitor, tidyverse, lubridate)


#Loading in the project ID====
my_project_id <- readRDS("../cloud_setup/projectid.RDS")

#Loading in the existing bucket list for the cloud====
bucket_list <- readRDS("../cloud_setup/utilities/bucket_list.rds")

bucketname <-  make_clean_names(bucketname)

#Checking if bucket name has been added to the list before - This is case sensitive====
if(!bucketname %in% bucket_list$bucket_name){
  #Creating a bucket====
  gcs_create_bucket(bucketname, 
                    my_project_id, 
                    location = "US")
  
  #Making it global/"Staging it"====
  gcs_global_bucket(bucketname)
  
  #Uploading the dataframe to the bucket====
  gcs_upload(df, name = make_clean_names(bucketname))
  
  #Saving the bucket to the local "bucket list"
  bucket_list_updated <- bucket_list %>%
    add_row(bucket_name = bucketname,
            last_updated = lubridate::date(Sys.Date()))
  
  bucket_list_updated <- bucket_list_updated  %>%
    arrange(desc(last_updated)) %>%
    drop_na()
  
  saveRDS(bucket_list_updated, "../cloud_setup/utilities/bucket_list.rds")
  
  message("Data was added to the bucket list and successfully pushed to the cloud!")
  
} else {
  #Making it global/"Staging it"====
  gcs_global_bucket(bucketname)
  
  #Uploading the dataframe to the bucket====
  gcs_upload(df, name = make_clean_names(bucketname))
  
  message("The existing bucket was updated and successfully pushed to the cloud!")
}

#Unloading the extra packages that may not be needed====
pacman::p_load(googleCloudStorageR, janitor, lubridate)

}

saveRDS(cloud_saver, "../cloud_setup/utilities/cloud_saver.rds")
