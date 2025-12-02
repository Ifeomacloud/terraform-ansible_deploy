# backend.tf
terraform { 
  cloud { 
    
    organization = "Audlaywears" 

    workspaces { 
      name = "terraform_ansible" 
    } 
  } 
}
