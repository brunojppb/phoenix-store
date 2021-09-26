function cartHandler(e) {
  e.preventDefault()
  const postUrl = $(this).attr('action')
  const formData = $(this).serialize()
  
  console.log('sending product..')
  $.post(postUrl, formData, res => {
    console.log('Response: ', res)
    $(".cart-count").text(`My Cart (${res.cart_count})`)
  })
}

const ajaxCart = {
  init: function() {
    $(function() {
      $('.cart-form').on('submit', cartHandler)
    })
  }
}

export default ajaxCart