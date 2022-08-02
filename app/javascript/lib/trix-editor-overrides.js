// app/javascript/trix-editor-overrides.js

window.addEventListener("trix-file-accept", function(event) {
  const acceptedTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp', 'image/apng']
  const maxFileSize = (1024 * 1024) * 5 // 5MB 

  if (!acceptedTypes.includes(event.file.type)) {
    event.preventDefault()
    alert(`Supported file types: ${acceptedTypes.join(', ').replaceAll('image/', '')}`)
  }

  if (event.file.size > maxFileSize) {
    event.preventDefault()
    alert("Attachments must be 5MB or smaller.")
  }
})