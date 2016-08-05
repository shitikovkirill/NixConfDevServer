<div id="contact_form">
    <h3>Get in Touch</h3>
    <form id="form">
        <div class="success_wrapper">
            <div class="success-message">Contact form submitted</div>
        </div>
        <label class="name">
            <input type="text" placeholder="Name*:" data-constraints="@Required @JustLetters" />
            <span class="empty-message">*This field is required.</span>
            <span class="error-message">*This is not a valid name.</span>
        </label>
        <label class="email">
            <input type="text" placeholder="E-mail*:" data-constraints="@Required @Email" />
            <span class="empty-message">*This field is required.</span>
            <span class="error-message">*This is not a valid email.</span>
        </label>
        <label class="phone">
            <input type="text" placeholder="Telephone:" data-constraints="@Required @JustNumbers"/>
            <span class="empty-message">*This field is required.</span>
            <span class="error-message">*This is not a valid phone.</span>
        </label>
        <label class="message">
            <textarea placeholder="Comment*:" data-constraints='@Required @Length(min=20,max=999999)'></textarea>
            <span class="empty-message">*This field is required.</span>
            <span class="error-message">*The message is too short.</span>
        </label>
        <div>
            <div class="clear"></div>
            <div class="btns">
                <a id="send-form" href="#" data-type="submit" class="btn">Submit</a>
                <span>*required fields</span>
            </div>
        </div>
        
    </form>
</div>