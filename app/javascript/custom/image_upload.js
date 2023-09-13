document.addEventListener("turbo:load", function() {
  const imgSizeMgMax = parseFloat(document.getElementById('js-constants').dataset.imgSizeMgMax);
  document.addEventListener("change", function(event) {
    let image_upload = document.querySelector('#micropost_image');
    const size_in_megabytes = image_upload.files[0].size/1024/1024;
    if (size_in_megabytes > imgSizeMgMax) {
      alert("Maximum file size is ${imgSizeMgMax}MB. Please choose a smaller file.");
      image_upload.value = "";
    }
  });
});
