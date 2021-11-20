import Rails from '@rails/ujs'
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['form']

  connect() {
    console.log(this.element)
    console.log(this.formTarget)
  }

  search() {
    console.log(Rails)
    Rails.fire(this.formTarget, 'submit')
  }
}
