#Main.tf
#resource block:

resource "local_file" "hi-pet"{
filename=var.filename
content=var.content
}
-------------------------------------------
#variable.tf
#variable block

variable "filename"{
default="/root/hipet.txt"

}
variable "content"{
default="hello pets"

}





















