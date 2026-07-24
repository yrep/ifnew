<script>
  let {
    width = undefined,
    height = undefined,
    class: className = '',
    href = '/'
  } = $props();
</script>

<a
  {href}
  class={`inline-flex items-center ${className}`}
  style:width={width != null ? (typeof width === 'number' ? width + 'px' : width) : undefined}
  style:height={height != null ? (typeof height === 'number' ? height + 'px' : height) : undefined}
>
  <svg
    viewBox="0 0 60 18"
    class="w-full h-full"
    style="fill-rule:evenodd;clip-rule:evenodd;stroke-linejoin:round;stroke-miterlimit:2;"
    xmlns="http://www.w3.org/2000/svg"
  >
    <g id="logo" transform="matrix(1.077789,0,0,1.077789,-2.333658,-1.185545)">
      <g transform="matrix(0.114901,0,0,0.114901,1.419565,-2.370104)">
        <path d="M108.99,178.826C88.298,161.386 87.009,129.742 115.49,112.951C165.734,83.328 268.891,95.967 324.219,84.445C393.335,70.053 409,54.397 425.99,37.701C417.708,51.924 416.479,80.479 412.756,99.233C399.445,166.28 330.536,172.382 272.49,178.826L490.99,178.826L490.99,30.201L6.49,30.201L6.49,178.826L108.99,178.826Z" fill="#19b200"/>
      </g>
      <g transform="matrix(0.114901,0,0,0.114901,1.419565,-2.370104)">
        <path d="M151.068,178.826C285.488,147.876 365.113,133.109 385.74,91.201C374.364,133.253 329.57,146.006 207.24,178.826L151.068,178.826Z" fill="#19b200"/>
      </g>
    </g>
  </svg>
</a>