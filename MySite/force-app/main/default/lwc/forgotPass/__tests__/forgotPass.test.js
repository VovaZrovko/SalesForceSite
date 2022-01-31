import { createElement } from 'lwc';
import forgotPass  from 'c/forgotPass';
import { ShowToastEventName } from 'lightning/platformShowToastEvent';

describe('c-forgot-pass test', ()=> {
    afterEach(() => {
      while(document.body.firstChild) {
        document.body.removeChild(document.body.firstChild);
      }
      jest.clearAllMocks();
    });
    async function flushPromises() {
        return Promise.resolve();
    }
    it('field inputed', ()=>{
      const element = createElement('c-forgot-pass', {
        is: forgotPass
       });
        document.body.appendChild(element);
        //element.yourEmail = 'vova@gmail.com';
        const inputElement = element.shadowRoot.querySelector('lightning-input');
        inputElement.value = 'vova@gmail.com';
        inputElement.dispatchEvent(new CustomEvent('change'));
        expect(inputElement.value).toBe('vova@gmail.com');
    });

    it('button recovery clicked', async ()=> {
      const element = createElement('c-forgot-pass', {
        is: forgotPass
      });
      document.body.appendChild(element);
      const showToastHandler = jest.fn();
      element.addEventListener(ShowToastEventName, showToastHandler);
      const inputElement = element.shadowRoot.querySelector('lightning-input');
      inputElement.value = 'vova@gmail.com';
      inputElement.dispatchEvent(new CustomEvent('change'));
      element.shadowRoot.querySelector('lightning-button[data-id="send"]').dispatchEvent(new CustomEvent('click'));
      await flushPromises();
      expect(element.error).toBe('');
    });
})