<script>
  import StyleSet from '@stackpress/ink/dist/style/StyleSet';
  import setBold from '../utilities/style/bold';
  import setDisplay from '../utilities/style/display';
  import setSize from '../utilities/style/size';
  //extract props
  const { value } = this.props;
  //sub-props (box size, text size)
  let { box, text } = this.propsTree;
  if (!box && text !== false) {
    box = {};
    text = true;
  }
  //override default styles
  const styles = new StyleSet();
  this.styles = () => styles.toString();
  //determine display
  const display = setDisplay(this.props, styles, 'inline-flex');
  if (display === 'flex' || display === 'inline-flex') {
    styles.add(':host', 'align-items', 'center');
  }
  //determine size
  setSize(this.props, styles, false, ':host', 'font-size');
  //determine font weight
  setBold(this.props, styles, ':host');
  //if there is box props
  if (box) {
    //build box class list
    styles.add(':host .box', 'display', 'inline-block');
    styles.add(':host .box', 'border-radius', '4px');
    styles.add(':host .box', 'border', '1px solid var(--black)');
    styles.add(':host .box', 'background-color', value);
    //determine box class size
    setSize(box, styles, '16px', '.box', 'width');
    setSize(box, styles, '16px', '.box', 'height');
  }
  //if there is text props
  if (text) {
    //add margin right to the box class list
    styles.add(':host .box', 'margin-right', '5px');
  }
</script>
<if true={box}>
  <span class="box"></span>
</if>
<if true={text}>
  <span class="text">{value}</span>
</if>