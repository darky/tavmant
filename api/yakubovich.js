module.exports = [{
  name: 'обвести_красным',
  fn (opts) {
    return `
      <div style='border: 2px solid red;'>
        ${opts.fn()}
      </div>
    `;
  },
  template: `\
{{#обвести_красным}}
  !!!содержимое!!!
{{/обвести_красным}}`
}];