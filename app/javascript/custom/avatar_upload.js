document.getElementById("avatar_upload_btn").addEventListener("click", (e) => {
  console.log("avatar_upload_btn");
  e.preventDefault();
  document.getElementById("avatar_upload_field").click();
});

document
  .getElementById("avatar_upload_field")
  .addEventListener("change", function () {
    const file = this.files[0];
    const reader = new FileReader();

    reader.onloadend = function () {
      document.getElementById("avatar_upload_btn").src = reader.result; // Update preview
    };
    if (file) {
      reader.readAsDataURL(file); // Read file and call onloadend
      console.log("Avatar file:", file.name);
      console.log("Avatar file path: ", URL.createObjectURL(file));
    }
  });
