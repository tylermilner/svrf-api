/* global AFRAME */
const svrf = require('./svrf');

/**
 * Component that listens to an event, fades out an entity, swaps the texture, and fades it
 * back in.
 */
AFRAME.registerComponent('set-image', {
  schema: {
    on: {type: 'string'},
    target: {type: 'selector'},
    dur: {type: 'number', default: 300}
  },

  init: function () {
    const data = this.data;
    const el = this.el;

    this.setupFadeAnimation();
    this.getImage();
    el.addEventListener(data.on, () => this.getImage());
  },

  getImage: function () {
    const data = this.data;
    // Fade image.
    data.target.emit('fade-image');

    return svrf.trending()
      .then((image) => {
        data.target.setAttribute('material', 'src', image);
      });
  },

  setupFadeAnimation: function () {
    const data = this.data;
    const targetEl = this.data.target;

    // Only set up once.
    if (targetEl.dataset.setImageFadeSetup) {
      return;
    }
  
    targetEl.dataset.setImageFadeSetup = true;

    // Create animation.
    targetEl.setAttribute('animation__fade', {
      property: 'material.color',
      startEvents: 'fade-image',
      dir: 'alternate',
      from: '#FFF',
      to: '#000',
    });
  }
});