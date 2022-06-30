# Erie County Department of Health Equity Project Initialization====

#Loading library for Google Cloud====
library(googleCloudStorageR)

#Setting the project ID and saving to the directory====
my_project_id <- "health-equity"
saveRDS(my_project_id,"projectid.RDS")

#Creating a bucket====
gcs_create_bucket("test_bucket", 
                  my_project_id, location = "US")

#Making it global/"Staging it"====
gcs_global_bucket("tester bucket")

#Writing test data to a bucket====
write.csv(mtcars, "mtcars.csv")
gcs_upload("mtcars.csv", name = "overused_tutorial_dataset")

# Listing buckets on the project
gcs_list_buckets(my_project_id)

#Deleting Buckets? - Look into this - deleting form here didnt delete on console
gcs_delete_object("overused_tutorial_dataset", bucket = "overused_tutorial_dataset")


