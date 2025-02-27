<link rel="import" type="component" href="./icon.ink" name="interface-icon" />
<script>
  import StyleSet from '@stackpress/ink/dist/style/StyleSet';
  import setBold from '../utilities/style/bold';
  import setColor from '../utilities/style/color';
  import setDisplay from '../utilities/style/display';
  import setSize from '../utilities/style/size';
  import setUnderline from '../utilities/style/underline';
  //define handlers
  const handlers = {
    click: (e) => {
      e.preventDefault();
      const page = e.target.innerText;
      handlers.select(Number(page));
      return false;
    },
    rewind: (e) => {
      e.preventDefault();
      handlers.select(1);
      return false;
    },
    forward: (e) => {
      e.preventDefault();
      handlers.select(Math.ceil(total / range));
      return false;
    },
    prev: (e) => {
      e.preventDefault();
      handlers.select(Math.max(1, state.current - 1));
      return false;
    },
    next: (e) => {
      e.preventDefault();
      handlers.select(Math.min(state.range[1], state.current + 1));
      return false;
    },
    select: (page: number) => {
      typeof select === 'function' && select(page);
      Object.assign(
        state, 
        handlers.calculate(total, (page - 1) * range, range, radius)
      );
      this.render();
    },
    calculate: (total = 0, start = 0, range = 50, radius = 2) => {
      //calculate the total number of pages
      //ex. 1000 / 100 = 10
      //ex. 1001 / 100 = 11
      const pages = Math.ceil(total / range);
      //calculate the current page
      //ex. 0 / 50 = 1
      //ex. 49 / 50 = 1
      //ex. 50 / 50 = 2
      const current = Math.ceil((start + 1) / range);
      //determine what pages to show, 
      //ex. if radius is 2 and page is 5, then show 3, 4, 5, 6, 7
      const numbers = Array
        .from({ length: pages }, (_, i) => i + 1)
        .filter(
          page => page >= current - radius && page <= current + radius
        );
      const minmax = [ numbers[0], numbers[numbers.length - 1] ];

      return { current, numbers, range: minmax, pages };
    }
  };
  //extract props
  const { 
    //variables
    total = 0, start = 0, range = 50, radius = 2,
    //flags
    next, prev, rewind, forward,
    //sub props (color)
    link, control, border, background,
    //layout
    square = 0,
    //default sizes (to pass to icon component)
    size, xs,  sm,  md,  lg, 
    xl,   xl2, xl3, xl4, xl5,
    //default colors (to pass to icon component)
    color,   white, black, info,    warning, 
    success, error, muted, primary, secondary,
    //handlers
    page: select = () => {}
  } = this.propsTree;
  //override default styles
  const styles = new StyleSet();
  this.styles = () => styles.toString();
  //determine host display
  setDisplay(this.props, styles, 'block', ':host');
  //determine host size
  setSize(this.props, styles, false, ':host', 'font-size');
  //determine host color
  setColor(this.props, styles, false, ':host', 'color');

  //default children styles
  styles.add('.control, a, span', 'display', 'inline-block');
  styles.add('.control:not(:defined)', 'display', 'none');
  styles.add('a', 'cursor', 'pointer');
  //determine children spacing
  if (square) {
    styles.add('.control, a, span', 'display', 'inline-flex');
    styles.add('.control, a, span', 'align-items', 'center');
    styles.add('.control, a, span', 'justify-content', 'center');
    styles.add('.control, a, span', 'text-align', 'center');
    styles.add('.control, a, span', 'width', `${square}px`);
    styles.add('.control, a, span', 'height', `${square}px`);
  }
  //determine children border
  if (border) {
    styles.add('.control, a, span', 'border-width', '1px');
    styles.add('.control, a, span', 'border-style', 'solid');
    setColor(border, styles, false, '.control, a, span', 'border-color');
  }
  //determine children background
  if (background) {
    setColor(background, styles, false, '.control, a, span', 'background-color');
  }
  //determine span bold
  setBold(this.props, styles, 'span');
  //determine link underline
  setUnderline(this.props, styles, 'a');
  //determine link color
  if (link) {
    setColor(link, styles, false, 'a', 'color');
  }
  //create local state (handled manually)
  const state = handlers.calculate(total, start, range, radius);
  //pass props from this component to icon component
  const iconProps = {
    //default sizes
    size, xs,  sm,  md,  lg, 
    xl,   xl2, xl3, xl4, xl5,
    //default colors
    color,   white, black, info,    warning, 
    success, error, muted, primary, secondary,
    //custom icon props
    ...(control || {})
  };
</script>
<if true={state.numbers.length > 1}>
  <if true={rewind && state.range[0] !== 1}>
    <interface-icon 
      {...iconProps} 
      class="control" 
      name="angles-left" 
      click={handlers.rewind} 
    />
  </if>
  <if true={prev && state.current > 1}>
    <interface-icon 
      {...iconProps} 
      class="control" 
      name="angle-left" 
      click={handlers.prev} 
    />
  </if>
  <each value=page from={state.numbers}>
    <if true={page === state.current}>
      <span>{page}</span>
    <else />
      <a click={handlers.click}>{page}</a>
    </if>
  </each>
  <if true={next && state.current < state.pages}>
    <interface-icon 
      {...iconProps} 
      class="control" 
      name="angle-right" 
      click={handlers.next} 
    />
  </if>
  <if true={forward && state.range[1] !== state.pages}>
    <interface-icon 
      {...iconProps} 
      class="control" 
      name="angles-right" 
      click={handlers.forward} 
    />
  </if>
</if>