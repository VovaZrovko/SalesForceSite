import { createElement } from 'lwc';
import forgotPass  from 'c/forgotPass';
import sendMSG from '@salesforce/apex/PasswordRecoveryController.sendMSG';
import { ShowToastEventName } from 'lightning/platformShowToastEvent';
import { getNavigateCalledWith } from 'lightning/navigation';
const TOAST_MESSAGE = 'The email was sent';

jest.mock(
  '@salesforce/apex/PasswordRecoveryController.sendMSG',
  ()=>{
    return {
      default: jest.fn()
    };
  },
  { virtual: true}
);
const APEX_RETURN = 'The email was sent';

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

    it('button back clicked', async ()=> {
      const NAV_TYPE = 'standard__navItemPage';
      const NAV_API_NAME = 'LWCReg';

      const element = createElement('c-forgot-pass', {
        is: forgotPass
      });

      document.body.appendChild(element);

      await flushPromises();
      
      const buttonEl = element.shadowRoot.querySelector('lightning-button[data-id="back"]');
      buttonEl.click();

      const { pageReference } = getNavigateCalledWith();

      expect(pageReference.type).toBe(NAV_TYPE);
      expect(pageReference.attributes.apiName).toBe(NAV_API_NAME);
    });
    
    it('button send clicked', async()=>{
      sendMSG.mockResolvedValue(APEX_RETURN);
      const element = createElement('c-forgot-pass', {
        is: forgotPass
      });

      document.body.appendChild(element);

      const handler = jest.fn();
      element.addEventListener(ShowToastEventName, handler);
      // fill input
      const inputElement = element.shadowRoot.querySelector('lightning-input');
      inputElement.value = 'vova@gmail.com';
      inputElement.dispatchEvent(new CustomEvent('change'));
      //button clicked with input
      let buttonSend = element.shadowRoot.querySelector('lightning-button[data-id="send"]');
      buttonSend.click();
      return Promise.resolve().then(()=>{
        expect(handler).toHaveBeenCalled();
        expect(sendMSG).toHaveBeenCalled();
        expect(handler.mock.calls[0][0].detail.message).toBe(
          TOAST_MESSAGE
        );
      })

    });
})