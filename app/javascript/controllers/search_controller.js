import Rails from '@rails/ujs'
import { Controller } from "@hotwired/stimulus"
import { debounce } from 'lodash'

export default class extends Controller {
  static targets = ['form']

  initialize() {
    this.search = debounce(this._performSearch, 500)
  }

  _performSearch() {
    Rails.fire(this.formTarget, 'submit')
  }
}
