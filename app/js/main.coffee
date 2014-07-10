# Working With Data

#dataset = [ 5, 10, 15, 20, 25, 30, 35, 40, 45, 50 ]
dataset = [ 5, 10, 13, 19, 21, 25, 22, 18, 15, 13, 11, 12, 15, 20, 18, 17, 16, 18, 23, 25 ]
dataset = [ { key: 0, value: 5 },
                { key: 1, value: 10 },
                { key: 2, value: 13 },
                { key: 3, value: 19 },
                { key: 4, value: 21 },
                { key: 5, value: 25 },
                { key: 6, value: 22 },
                { key: 7, value: 18 },
                { key: 8, value: 15 },
                { key: 9, value: 13 },
                { key: 10, value: 11 },
                { key: 11, value: 12 },
                { key: 12, value: 15 },
                { key: 13, value: 20 },
                { key: 14, value: 18 },
                { key: 15, value: 17 },
                { key: 16, value: 16 },
                { key: 17, value: 18 },
                { key: 18, value: 23 },
                { key: 19, value: 25 } ]

key = (d) -> d.key

h = 300
w = 600
scale = 4
barPadding = 1

# writing as text
###
d3.select("body").selectAll("p")
 .data(dataset)
 .enter()
 .append("p")
 .text((d) -> d)
 .style("color", (d) -> 
  switch 
   when d < 16 then "black"
   else "red"
   
 )
###
# making divs
###
d3.select("body").selectAll("div")
 .data(dataset)
 .enter()
 .append("div")
 .attr("class", "bar")
 .style("height", (d) -> d*5 + "px")
 

###

#svg

svg = d3.select("body").append("svg")
svg.attr("width", w).attr("height", h)

#circles
###
circles = svg.selectAll("circle").data(dataset).enter().append("circle")

circles.attr("cx", (d, i) ->  (i * 50) + 25 )
       .attr("cy", h/2)
       .attr("r", (d) -> d )
       .classed("pumpkin",true)
###       

#bars
baseD = (d) -> d.value
datasetMax = d3.max(dataset,baseD)

barXScale = d3.scale.ordinal()
                .domain(d3.range(dataset.length))
                .rangeRoundBands([0, w], 0.05)
                
barYScale = d3.scale.linear()

barYScale.domain([0,d3.max(dataset,baseD)])
barYScale.range([h,0])

bars = svg.selectAll("rect")
   .data(dataset, key)
   .enter()
   .append("rect")
   
bars.attr("x", (d,i) -> barXScale(i)) #i*(w/dataset.length))
   .attr("y", (d) -> barYScale(d.value)) #h-(d*scale))
   .attr("width", barXScale.rangeBand() )
   .attr("height", (d) -> h-barYScale(d.value) ) #d*scale )
   .attr("fill",(d) -> "rgb(0, 0, " + (d.value * 10) + ")")
   .append("title")
   .text((d) ->
     "This value is " + d.value
   )


###
# conflicts with other transitions (like sorts)

bars.on "mouseover", (d) ->
 d3.select(this).attr("fill","orange")
 
bars.on "mouseout", (d) ->
 d3.select(this).transition().duration(150).attr("fill","rgb(0, 0, " + (d.value * 10) + ")")   
###
   
#labels for the bars

texts = svg.selectAll("text").data(dataset, key).enter().append("text")
texts.text((d)->d.value)
 .attr("x", (d, i) -> barXScale(i)+(barXScale.rangeBand()/2))
 .attr("y", (d) -> barYScale(d.value)+14)
 .attr("font-family", "sans-serif")
 .attr("font-size", "11px")
 .attr("fill", "white")
 .attr("text-anchor","middle")
 .style("pointer-events","none")
 

#static dataset
#dataset2 = [[5, 20], [480, 90], [250, 50], [100, 33], [330, 95],[410, 12], [475, 44], [25, 67], [85, 21], [220, 88], [600, 150]]

#random dataset
dataset2 = []
numDataPoints = 50
xRange = Math.random() * 1000
yRange = Math.random() * 1000

for i in [0..numDataPoints] by 1
 newNumber1 = (Math.round(Math.random() * xRange))/1000
 newNumber2 = Math.round(Math.random() * yRange)
 dataset2.push([newNumber1, newNumber2])


scatterPadding = 30

xScale = d3.scale.linear()
                 .domain([0,d3.max(dataset2,(d)-> d[0])])
                 .range([scatterPadding,w-scatterPadding*2])

yScale = d3.scale.linear()
                 .domain([0,d3.max(dataset2,(d)-> d[1])])
                 .range([h-scatterPadding,scatterPadding])
                 
rScale = d3.scale.linear()
                 .domain([0,d3.max(dataset2,(d)-> d[1])])
                 .range([2,5])


svg2 = d3.select("body").append("svg")
svg2.attr("width", w).attr("height", h)

svg2.append("clipPath")                  #Make a new clipPath
    .attr("id", "chart-area")            #Assign an ID
    .append("rect")                      #Within the clipPath, create a new rect
    .attr("x", scatterPadding)                  #Set rect's position and size…
    .attr("y", scatterPadding)
    .attr("width", w - scatterPadding * 3)
    .attr("height", h - scatterPadding * 2)

circles2 = svg2.append("g")                             #Create new g
   .attr("id", "circles")                   #Assign ID of 'circles'
   .attr("clip-path", "url(#chart-area)")   #Add reference to clipPath via SVG spec
   .selectAll("circle").data(dataset2).enter().append("circle")

circles2.attr("cx", (d)-> xScale(d[0]) )
 .attr("cy", (d) -> yScale(d[1]) )
 .attr("r", (d)-> rScale(d[1]))

###
text2 = svg2.selectAll("text").data(dataset2).enter().append("text")
text2.text((d) -> d[0] + ',' + d[1])
 .attr("x",(d) -> xScale(d[0]))
 .attr("y",(d) -> yScale(d[1]))
 .attr("font-family","sans-serif")
 .attr("font-size","11px")
 .attr("fill","red")
###

formatAsPercentage = d3.format(".1%")

xAxis = d3.svg.axis()
 .scale(xScale)
 .orient("bottom")
 .ticks(5)
 #.tickFormat(formatAsPercentage)
 
yAxis = d3.svg.axis()
 .scale(yScale)
 .orient("left")
 .ticks(5)

svg2.append("g")
 .attr("class", "x axis")
 .attr("transform","translate(0,"+(h-scatterPadding)+")")
 .call(xAxis)

svg2.append("g")
 .attr('class','y axis')
 .attr('transform','translate('+scatterPadding+',0)')
 .call(yAxis)



#sorting
sortOrder = false

sortBars = () ->
 sortOrder = !sortOrder
 
 svg.selectAll("text")
  .sort( (a,b) ->
   if sortOrder 
      d3.ascending(a.value,b.value) 
     else
      d3.descending(a.value,b.value)
   )
   .transition()
   .delay( (d,i) -> i*50 )
   .duration(1000)
   .attr("x", (d, i) -> barXScale(i)+(barXScale.rangeBand()/2))

 
 svg.selectAll("rect")
    .sort( (a,b) ->
     if sortOrder 
      d3.ascending(a.value,b.value) 
     else
      d3.descending(a.value,b.value)
    )
    .transition()
    .delay( (d,i) -> i*50 )
    .duration(1000)
    .attr("x", (d,i) -> barXScale(i))



 
#Loading Data
 
d3.csv "sample.csv", (error, data) ->
 console.log error
 console.log data
 
 
 
#transitions on clicks

maxValue = 25

updateBars = (bars, texts) ->
 bars.transition()
  .duration(500)
  .attr("x",(d,i) -> barXScale(i))
  .attr("y",(d) -> barYScale(d.value))
  .attr("width",barXScale.rangeBand())
  .attr("height",(d) -> h - barYScale(d.value) )
  
 texts.transition()
  .duration(500)
  .text( (d) -> d.value)
  .attr("x", (d, i) -> barXScale(i) + barXScale.rangeBand() / 2)
  .attr("y", (d) -> barYScale(d.value) + 14)

d3.select("p.barRemove").on "click", ->
 dataset.shift()
 
 barXScale.domain(d3.range(dataset.length))
 barYScale.domain([0,d3.max(dataset,baseD)])
 
 bars = svg.selectAll("rect").data(dataset, key)
 bars.exit()
  .transition()
  .duration(500)
  .attr("x", -barXScale.rangeBand())
  .remove()
 
 texts = svg.selectAll("text").data(dataset, key)
 texts.exit()
  .transition()
  .duration(500)
  .attr("x",-barXScale.rangeBand())
  .remove()
  
 updateBars(bars,texts)


d3.select("p.barAdd").on "click", ->
 newNumber = Math.floor(Math.random() * maxValue)
 lastKeyValue = dataset[dataset.length - 1].key
 dataset.push({ key: lastKeyValue + 1, value: newNumber })
 
 barXScale.domain(d3.range(dataset.length))
 barYScale.domain([0,d3.max(dataset,baseD)])
 
 bars = svg.selectAll("rect").data(dataset, key)
 
 bars.enter()
    .append("rect")
    .attr("x", w)
    .attr("y", (d) -> barYScale(d.value))
    .attr("width", barXScale.rangeBand())
    .attr("height", (d) -> h-barYScale(d.value))
    .attr("fill", (d) -> "rgb(0, 0, " + (d.value * 10) + ")")
    
 bars.transition()
  .duration(500)
  .attr("x",(d,i) -> barXScale(i))
  .attr("y",(d) -> barYScale(d.value))
  .attr("width",barXScale.rangeBand())
  .attr("height",(d) -> h - barYScale(d.value) )
 
 texts = svg.selectAll("text").data(dataset, key)
 
 texts.enter()
  .append("text")
  .text((d) -> d.value)
  .attr("x",w)
  .attr("y",(d) -> barYScale(d.value)+14)
  .attr("font-family", "sans-serif")
  .attr("font-size", "11px")
  .attr("fill", "white")
  .attr("text-anchor","middle")
 
 texts.transition()
  .duration(500)
  .text( (d) -> d.value)
  .attr("x", (d, i) -> barXScale(i) + barXScale.rangeBand() / 2)
  .attr("y", (d) -> barYScale(d.value) + 14)

d3.select("p.bar").on "click", ->

  numValues = dataset.length                         #Count original length of dataset
  dataset = []                                       #Initialize empty array
  for i in [0..numValues]                            #Loop numValues times
    newNumber = Math.floor(Math.random() * maxValue) #New random integer (0-24)
    dataset.push({'key':i,'value':newNumber})        #Add new number to array

  barYScale.domain([0,d3.max(dataset, baseD)])
  
  speed = 500
  ease = "circle"
  delay = (d,i) -> i / dataset.length * 1000
  
  svg.selectAll("rect")
     .data(dataset, key)
     .transition()
     .delay(delay)
     .duration(speed)
     .ease(ease)
     .attr("y", (d) -> barYScale(d.value) )
     .attr("height", (d) -> h - barYScale(d.value) )
     .attr("fill", (d) -> "rgb(0,0, " + (d.value*10)+")")

  svg.selectAll("text")
   .data(dataset, key)
   .transition()
   .delay(delay)
   .duration(speed)
   .ease(ease)
   .text((d)->d.value)
   .attr("y", (d) -> barYScale(d.value)+14)

d3.select("p.barSort").on "click", ->
 sortBars()
 

d3.select("p.scatter").on "click", ->
  numDataPoints = dataset2.length
  dataset2 = []
  xRange = Math.random() * 1000
  yRange = Math.random() * 1000
  
  for i in [0..numDataPoints] by 1
   newNumber1 = (Math.round(Math.random() * xRange))/1000
   newNumber2 = Math.round(Math.random() * yRange)
   dataset2.push([newNumber1, newNumber2])
  
  #update the x & y scales
  xScale.domain([0,d3.max(dataset2,(d)-> d[0])])
  yScale.domain([0,d3.max(dataset2,(d)-> d[1])])
  
  svg2.selectAll("circle")
   .data(dataset2)
   .transition()
   .duration(1000)
   .each("start", ->
     d3.select(this)
      .attr("fill", "magenta")
      .attr("r",9)
   )
   .attr("cx", (d)->xScale(d[0]))
   .attr("cy", (d)->yScale(d[1]))
   .each("end", ->
     d3.select(this)
      .transition()
      .duration(1000)
      .attr("fill","black")
      .attr("r",(d) -> rScale(d[1]))
   )
   
  svg2.select(".x.axis")
   .transition()
   .duration(1000)
   .call(xAxis)
   
  svg2.select(".y.axis")
   .transition()
   .duration(1000)
   .call(yAxis)
