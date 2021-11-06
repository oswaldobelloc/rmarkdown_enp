---
title: "Pruebas que Usan Datos de Una Muestra Aleatoria Simple"
author:
  name: "Prof: Oswaldo Bello (oswaldobelloc@gmail.com)"
  affiliation: "Universidade de Oriente, Venezuela"
date: "Sábado, 06 de noviembre de 2021 (12:23:12 a.m.)"
logo: "logo.png"
output:  
  bookdown::html_document2:
    toc: yes
    toc_depth: 3
    toc_float: yes
    smooth_scroll: yes
    number_sections: yes
    anchor_sections: yes
    theme: journal
    highlight: pygments
    df_print: paged
    code_folding: hide
    code_download: no
    self_contained: yes
# bibliography: "packages.bib"
# biblio-style: "apalike"
# link-citations: true
lang: es-ES
language:
  label:
    fig: 'Figura '
    tab: 'Tabla '
    eq: 'Ecuación '
    thm: 'Teorema '
    lem: 'Lema '
    cor: 'Corolario '
    prp: 'Proposición '
    cnj: 'Conjectura '
    def: 'Definición '
    exm: 'Ejemplo '
    exr: 'Ejercicio '
    hyp: 'Hipótesis '
    proof: 'Demostración. '
    remark: 'Nota: '
    solution: 'Solución. '
  ui:
    edit: Edit
    chapter_name: 'Capítulo '
    appendix_name: 'Apéndice '
delete_merged_file: yes   
---

<style type="text/css">
pre {
  max-height: 300px;
  overflow-y: auto;
}

pre[class] {
  max-height: 300px;
}
</style>


<style type="text/css">
.watch-out {
  background-color: lightpink;
  border: 3px solid red;
  font-weight: bold;
}
</style>


<style type="text/css">
.scroll-100 {
  max-height: 100px;
  overflow-y: auto;
  background-color: inherit;
}
</style>









<br/>

# Pruebas que Usan Datos de una Muestra Aleatoria Simple {#una-muestra}

En este núcleo temático se describen de manera teórica algunas pruebas no paramétricas que usan una muestra aleatoria simple para hacer inferencias acerca de los parámetros de la población de la cual fue tomada. Dentro de estas pruebas se encuentran:

1.  ***La Prueba Binomial*** (Sección \@ref(binomial1))

2.  ***La Prueba del Signo*** (Sección \@ref(signo1))

3.  ***La Prueba de Bondad de Ajuste Ji-cuadrado*** (Sección \@ref(jicuadrado1))

4.  ***La Prueba de Bondad de Ajuste Kolmogorov-Smirnov*** (Sección \@ref(kolgomorov1))

5.  ***La Prueba de Rachas o Carreras de Walf-Wolfowitz*** (Sección \@ref(rachas1))

Una vez descrita estas pruebas se procede, mediante ejemplos, a la implementación en <span style='color: blue;'>R</span> de las mismas.

El siguiente bloque de código permite instalar y cargar los paquetes usados para implementar estas pruebas en <span style='color: blue;'>R</span>.


```{.r .watch-out}
packages <- c(
  "rmarkdown", "bookdown", "bookdownplus", "magrittr",
  "kableExtra", "BSDA", "DT", "devtools", "tidyverse",
  "htmltools", "htmlwidgets", "utf8", "stringr", "MASS",
  "Hmisc", "kolmim", "hrbrthemes", "plotly", "NSM3",
  "reshape2", "randtests", "snpar", "knitcitations"
)
package.check <- lapply(packages, FUN = function(x) {
  if (!require(x, character.only = TRUE)) {
    install.packages(x, dependencies = TRUE)
    library(x, character.only = TRUE)
  }
})
```
<br/>

## Prueba Binomial {#binomial1}

La prueba binomial es una prueba no paramétrica utilizada para contrastar hipótesis referente a la proporción de individuos de una poblacional que poseen una característica de interés. La aplicación de este test requiere que la variable objeto de estudio sea categórica dicotómica o se haya dicotomizado a través de alguna transformación.

### Racionalización de la Prueba Binomial {#racionalizacion-binomial1}

En muchos problemas de la vida real el estudio se centra en analizar variables aleatorias de tipo categóricas dicotómicas (o que se han dicotomizado a través de alguna transformación). Suponga que una de las categorías se codifica como éxito de acuerdo si el valor observado en la variable se corresponde con una característica de interés, de lo contrario se codifica como fracaso. Si se toma una muestra aleatoria cualquiera de tamaño $n$ de esta variable, tal que:

$$
X_{i}=\begin{cases}
1, & \textit{si el i-ésimo valor observado en la muestra es un éxito}\\ 
0, & \textit{si el i-ésimo valor observado en la muestra es un fracaso}  
\end{cases},
$$

con $i=1, 2, \dotsc,n$. Suponiendo que para cada valor observado en la muestra, la probabilidad de que éste sea un éxito es constante e igual a $p$, es decir, $(P(X_i=1)=p)$, lo que implica que la probabilidad de observar un fracaso es $q=1-p$. Visto desde otro punto de vista, $p$ puede ser interpretado como la proporción de individuos en la población, de la cual se extrajo la muestra, que poseen la característica de interés; lo cual se justifica si la muestra se toma con reemplazo, si la población es infinita o si la población es finita tal que la aproximación de la distribución hipergeométrica a la distribución binomial sea adecuada. En base a lo anterior, se define el estadístico de prueba

$$
\begin{equation}
X=\sum_{i=1}^{n}X_{i},
(\#eq:estadistico-binomial)
\end{equation}
$$

el cual representa el número de éxitos o individuos que poseen la característica de interés en la muestra. Bajo los supuestos establecidos anteriormente, este estadístico tiene una distribución binomial con parámetros $n$ y $p$, es decir, $X\sim B\left ( n,p \right )$. En tal sentido, la probabilidad de observar de manera exacta $x$ éxitos en una muestra viene dada por la función de probabilidad binomial, la cual se muestra a continuación:

$$
\begin{equation}
P\left ( X=x \right )=p_{B}\left ( x,\ n,\ p \right  )=\binom{n}{x}p^{x}q^{n-x}, \ x= 0, 1, 2, \dotsc, n, \ n>0 \ y \ 0<p<1.
(\#eq:fmp-binomial)
\end{equation}
$$

Mientras que la probabilidad de obtener a lo más $x$ éxitos se puede calcular a través de la función de distribución acumulada de probabilidad binomial, la cual se muestra en la siguiente ecuación:

$$
\begin{equation}
P\left ( X\leq x \right )=F_{B}\left ( x,\ n,\ p \right )=\sum_{i=0}^{x}\binom{n}{i}p^{i}q^{n-i}, \ x= 0, 1, 2, \dotsc, n, \ n>0 \ y \ 0<p<1.
(\#eq:fdp-binomial)
\end{equation}
$$

Por otro lado, si se quiere contrastar la hipótesis nula de que la proporción de individuos en la muestra que poseen la característica de interés es $p_{0}$ $\left(H_0: p=p_0\right)$ contra la hipótesis alternativa unilateral superior de que la proporción de individuos en la población que poseen esta característica es mayor que la establecida en $H_{0}$, es decir, $H_1:p>p_{0}$. En base a la información de una muestra, una estimación de $p$ daría luces al respecto. Se sabe que $\widehat{P}=\frac{X}{n}$ es el estimador de máxima verosimilitud de $p$, por lo tanto si $x$ es el valor de $X$ observado en la muestra, $\widehat{p}=\frac{x}{n}$ es una estimación de $p$. Ahora, si se supone que la hipótesis nula es cierta $\widehat{p}$ debe ser próximo a $p_{0}$, de lo contrario habría indicios de que esta hipótesis es falsa. Una forma de medir esta distancia, en términos relativos, entre $\widehat{p}$ y $p_{0}$ es a través de la probabilidad de obtener un valor $\widehat{P}$ tan grande o más extremo que $\widehat{p}$ ($p_{valor}$), es decir, $P\left ( \widehat{P}\geq \widehat{p} \right )=p_{valor}$. Pero como la distribución de $\widehat{P}$ es desconocida, se usa la distribución de $X$ para calcular el $p_{valor}$. Dado que $X$ se distribuye binomialmente, bajo la hipótesis nula, con parámetros $n$ y $p=p_{0}$, el $p_{valor}$ se calcula de la siguiente manera:

$$
p_{valor}=P\left ( \widehat{P} \geq \widehat{p}\right )=P\left ( \frac{X}{n} \geq \frac{x}{n}\right )=P\left ( X\geq x \right )=1-P\left ( X\leq x-1 \right ).
$$

Dado que, bajo la hipótesis nula, $X\sim B\left ( n,p = p_{0} \right )$, de la ecuación \@ref(eq:fdp-binomial), el $p_{valor}$, viene determinado por:

$$
\begin{equation}
p_{valor}=1-F_{B}\left ( x-1, \ n, \ p=p_{0} \right )=1-\sum_{i=0}^{x-1}\binom{n}{i}p^{i}q^{n-i}.
(\#eq:pus-binomial)
\end{equation}
$$

En caso de que la hipótesis alternativa sea unilateral inferior, es decir, $H_{1}:p<p_{0}$, el $p_{valor}$ representa la probabilidad de encontrar un valor de $\widehat{P}$ tan pequeño o más pequeño $\widehat{p}$. O sea,

$$
p_{valor}=P\left ( \widehat{P} \leq \widehat{p}\right )=P\left ( \frac{X}{n} \leq \frac{x}{n}\right )=P\left ( X\leq x \right )=P\left ( X\leq x \right ).
$$

Lo que se puede reescribir, según la ecuación \@ref(eq:fdp-binomial), de la siguiente manera,

$$
\begin{equation}
p_{valor}=F_{B}\left (x, \ n, \ p=p_{0} \right )=\sum_{i=0}^{x}\binom{n}{i}p^{i}q^{n-i}.
(\#eq:pui-binomial)
\end{equation}
$$

Si el $p_{valor}\leq\alpha$ se acepta $H_{1}$, ya sea que esta haya sido planteado en forma unilateral superior o unilateral inferior.

Para una hipótesis alternativa de dos colas, $H_{1}=p \neq p_0$ , el $p_{valor}$ viene dado por:

$$
\begin{equation}
p_{valor}=
\begin{cases} 
2\left [ 1-F_{B}\left ( x-1,\ n,\ p_{0} \right ) \right ], \ \textit{si} \ x> np_{0} \\ 
2F_{B}\left ( x,\ n, \ p_{0} \right ), \ \textit{si} \ x\leq np_{0} 
 \end{cases}.
(\#eq:pbl-binomial)
\end{equation}
$$

Note que el cálculo del $p_{valor}$ depende de la evaluación de la función de distribución binomial $\left ( F_{B} \left ( x,n,p_{0} \right )\right )$, la cual se encuentra ampliamente tabulada para diferentes valores de $n$ y $p$ (generalmente $n\leq25$ y $p\leq1/2$). En la actualidad estas tablas han quedado en desuso dado que existen una gran cantidad de softwares informáticos que permiten evaluar esta función sin prácticamente restricciones sobre estos parámetros. En este sentido, la distribución base de <span style='color: blue;'>R</span> proporciona las funciones:

-   `dbinom(x, size, prob, log = FALSE)`

-   `pbinom(q, size, prob, lower.tail = TRUE, log.p = FALSE)`

-   `qbinom(p, size, prob, lower.tail = TRUE, log.p = FALSE)`

-   `rbinom(n, size, prob)`.

La función `dbinom` permite evaluar la función de masa de probabilidad binomial definida por la ecuación \@ref(eq:fmp-binomial), `pbinom` calcula la función de distribución binomial descrita por la ecuación \@ref(eq:fdp-binomial), `qbinom` determina los cuantiles binomiales y `rbinom` genera números pseudoaleatorios binomiales. Los parámetros de estas funciones se describen en la tabla \@ref(tab:par-dist-binom).

(ref:foo2) Descripción de los parámetros de funciones  de <span style='color: blue;'>R</span> relacionadas con la distribución binomial


```{.r .watch-out}
knitr::kable(
  data.frame(
    stringsAsFactors = TRUE,
    Parámetros = c(
      "x, q", "p", "n", "size", "prob", "log, log.p", "lower.tail"
    ),
    Descripción = c(
      "Vector de cuantiles.",
      "Vector de Probabilidades.",
      "Número de observaciones. Si length(n) > 1, se considera que la longitud es el número requerido.",
      "Número de ensayos (cero o más).",
      "Probabilidad de éxito en cada ensayo.",
      "Lógico; si es TRUE, las probabilidades p se dan como log(p).",
      "Lógico; si es TRUE (por defecto), las probabilidades son $P[X     \\leq x]$, de lo contrario, $P[X > x]$."
    )
  ),
  booktabs = TRUE,
  caption = "(ref:foo2)",
  escape = FALSE
) %>%
  kable_styling(
    bootstrap_options = "striped",
    full_width = FALSE,
    fixed_thead = T
  ) %>%
  kable_classic_2()
```

<table class="table table-striped lightable-classic-2" style='width: auto !important; margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
<caption>(\#tab:par-dist-binom)(ref:foo2)</caption>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> Parámetros </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> Descripción </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> x, q </td>
   <td style="text-align:left;"> Vector de cuantiles. </td>
  </tr>
  <tr>
   <td style="text-align:left;"> p </td>
   <td style="text-align:left;"> Vector de Probabilidades. </td>
  </tr>
  <tr>
   <td style="text-align:left;"> n </td>
   <td style="text-align:left;"> Número de observaciones. Si length(n) &gt; 1, se considera que la longitud es el número requerido. </td>
  </tr>
  <tr>
   <td style="text-align:left;"> size </td>
   <td style="text-align:left;"> Número de ensayos (cero o más). </td>
  </tr>
  <tr>
   <td style="text-align:left;"> prob </td>
   <td style="text-align:left;"> Probabilidad de éxito en cada ensayo. </td>
  </tr>
  <tr>
   <td style="text-align:left;"> log, log.p </td>
   <td style="text-align:left;"> Lógico; si es TRUE, las probabilidades p se dan como log(p). </td>
  </tr>
  <tr>
   <td style="text-align:left;"> lower.tail </td>
   <td style="text-align:left;"> Lógico; si es TRUE (por defecto), las probabilidades son $P[X     \leq x]$, de lo contrario, $P[X > x]$. </td>
  </tr>
</tbody>
</table>
<br/>
También, la distribución base de <span style='color: blue;'>R</span> proporciona la función `binom.test(x, n, p = 0.5, alternative = c("two.sided", "less", "greater"), conf.level = 0.95)`; la cual ejecuta la prueba binomial exacta. La descripción de los parámetros de esta función se muestran en la tabla \@ref(tab:par-prueba-binom).

(ref:foo) Descripción de los parámetros de la función `binom.test` de <span style='color: blue;'>R</span>


```{.r .watch-out}
knitr::kable(
  data.frame(
    stringsAsFactors = FALSE,
    Parámetros = c("x", "n", "p", "alternativa", "conf.level"),
    Descripción = c(
      "Número de éxitos, o un vector de longitud 2 que indique el número de éxitos y fracasos, respectivamente.",
      "Número de ensayos; se ignora si x tiene longitud 2.",
      "La probabilidad de éxito especificada en la hipótesis nula",
      "Indica la hipótesis alternativa y debe ser: \"two.sided\",
      \"greater\" o \"less\". Puede especificar sólo la letra inicial.",
      "Nivel de confianza para el intervalo de confianza establecido."
    )
  ),
  booktabs = TRUE,
  caption = "(ref:foo)",
  escape = FALSE
) %>%
  kable_styling(
    bootstrap_options = "striped",
    full_width = FALSE,
    fixed_thead = T
  ) %>%
  kable_classic_2()
```

<table class="table table-striped lightable-classic-2" style='width: auto !important; margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
<caption>(\#tab:par-prueba-binom)(ref:foo)</caption>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> Parámetros </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> Descripción </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> x </td>
   <td style="text-align:left;"> Número de éxitos, o un vector de longitud 2 que indique el número de éxitos y fracasos, respectivamente. </td>
  </tr>
  <tr>
   <td style="text-align:left;"> n </td>
   <td style="text-align:left;"> Número de ensayos; se ignora si x tiene longitud 2. </td>
  </tr>
  <tr>
   <td style="text-align:left;"> p </td>
   <td style="text-align:left;"> La probabilidad de éxito especificada en la hipótesis nula </td>
  </tr>
  <tr>
   <td style="text-align:left;"> alternativa </td>
   <td style="text-align:left;"> Indica la hipótesis alternativa y debe ser: "two.sided",
      "greater" o "less". Puede especificar sólo la letra inicial. </td>
  </tr>
  <tr>
   <td style="text-align:left;"> conf.level </td>
   <td style="text-align:left;"> Nivel de confianza para el intervalo de confianza establecido. </td>
  </tr>
</tbody>
</table>
<br/>
Como se dijo anteriormente, el cálculo del $p_{valor}$ depende de la evaluación de la función de distribución acumulada binomial dada en la ecuación \@ref(eq:fdp-binomial), lo que implica un gran volumen de cálculo cuando el tamaño de la muestra es grande. Pero, dado que $X$ es una suma de $n$ variables aleatorias independientes de Bernoulli, por el teorema del límite central, la distribución de $X$ se aproxima a la normal en la medida que $n$ tiende a infinito. Esta convergencia se acelera en la medida que $p$ tienda $\frac{1}{2}$. Al respecto, Canavos (1988, pág. 142), establece como criterio de una adecuada aproximación si $np>5$ cuando $p≤\frac{1}{2}$ o si $nq>5$ cuando $p>\frac{1}{2}$. Como $X$ se distribuye binomialmente, bajo la hipótesis nula, su media viene dada por $\mu_{X}=np_{0}$ y su varianza por $\sigma_{X}=np_{0}q_{0}$. En consecuencia, la variable aleatoria $X\simeq N\left ( \mu_{X}=np_{0}, \sigma_{X}=\sqrt{np_{0}q_{0}} \right )$. Por lo que:

$$
\begin{equation}
Z=\frac{X-np_{0}}{\sqrt{np_{0}q_{0}}},
(\#eq:z-binomial)
\end{equation}
$$

tiene distribución aproximadamente normal estándar, es decir, $Z\simeq N\left(\mu_{Z}=0, \sigma_{Z}=1\right)$, para un $n$ suficientemente grande. Note que lo que se intenta es aproximar probabilidades de una variable discreta a partir de una variable aleatoria continua, por lo que la aproximación puede mejorarse aplicando la corrección por continuidad de Yate. En este caso el estadístico $Z$ se redefine de la siguiente manera,

$$
\begin{equation}
Z=\frac{\left(X\pm 0,5 \right)-np_{0}}{\sqrt{np_{0}q_{0}}},
(\#eq:zcorr-binomial)
\end{equation}
$$

donde $X + 0,5$ se usa cuando $X < np$ y $X - 0,5$ se usa cuando$X > np$.

En el caso de una hipótesis alternativa unilateral superior $\left(H_1:p>p_{0}\right)$, la aproximación del $p_{valor}$ se obtiene de la siguiente manera:

$$
p_{valor}=P\left ( X\geq x \right )=  1-P\left ( X\leq x-1 \right )\cong 1-P\left ( Z\leq \frac{x-0,5-np_{0}}{\sqrt{np_{0}q_{0}}} \right ).
$$

En resumen,

$$
\begin{equation}
p_{valor}\cong 1-F_{N}\left ( Z= \frac{x-0,5-np_{0}}{\sqrt{np_{0}q_{0}}}, \ \mu_{Z}=0, \ \sigma_{Z}=1 \right ).
(\#eq:paproxus-binomial)
\end{equation}
$$

Ahora, cuando la hipótesis alternativa es unilateral inferior $\left(H_1: p<p_0\right)$, la aproximación del $p_{valor}$ se obtiene, usando la corrección de Yate, como sigue:

$$
p_{valor}=P\left(X \leq x\right) \cong P\left(X≤x+0,5\right).
$$

Es decir,

$$
\begin{equation}
p_{valor}\cong F_{N}\left ( Z= \frac{x+0,5-np_{0}}{\sqrt{np_{0}q_{0}}}, \ \mu_{Z}=0, \ \sigma_{Z}=1 \right ).
(\#eq:paproxui-binomial)
\end{equation}
$$

Una aproximación del $p_{valor}$, cuando la prueba de hipótesis es bilateral $\left(H_1: p\neq p_0\right)$, se obtiene con la siguiente ecuación

$$
\begin{equation}
p_{valor}\cong \begin{cases}
2\left [ 1-F_{N}\left ( Z=\frac{x-0,5-np_{0}}{\sqrt{np_{0}q_{0}}},  \ \mu_{Z}=0, \ \sigma_{Z}=1\right ) \right ] , \ \textit{si} \ x>np_{0} \\ 
2 F_{N}\left ( Z= \frac{x+0,5-np_{0}}{\sqrt{np_{0}q_{0}}} ,\ \mu_{Z}=0, \ \sigma_{Z}=1\right ), \ \textit{si} 
\ x \leq np_{0} 
\end{cases}. 
(\#eq:paproxbl-binomial)
\end{equation}
$$

Como se puede observar, el calculo del $p_{valor}$ aproximado depende de la función de distribución normal estándar, como se observa en las ecuaciones \@ref(eq:paproxus-binomial), \@ref(eq:paproxui-binomial) y \@ref(eq:paproxbl-binomial). La distribución base de <span style='color: blue;'>R</span> proporciona esta y otras funciones relacionadas con la distribución normal, tales como:

-   `dnorm(x, mean = 0, sd = 1, log = FALSE)`

-   `pnorm(q, mean = 0, sd = 1, lower.tail = TRUE, log.p = FALSE)`

-   `qnorm(p, mean = 0, sd = 1, lower.tail = TRUE, log.p = FALSE)`

-   `rnorm(n, mean = 0, sd = 1)`.

La tabla \@ref(tab:par-dist-normal) describe los parámetros de estas funciones

(ref:foo3) Descripción de los parámetros de  funciones de <span style='color: blue;'>R</span> relacionadas con la distribución normal


```{.r .watch-out}
knitr::kable(
  data.frame(
    stringsAsFactors = FALSE,
    Parámetros = c(
      "x, q", "p", "n", "mean",
      "sd", "log, log.p", "lower.tail"
    ),
    Descripción = c(
      "Vector de cuantiles.",
      "Vector de Probabilidades.",
      "Número de observaciones. Si length(n) > 1, se considera que la longitud es el número requerido.", "Vector de medias.",
      "Vector de desviaciones estándar.",
      "Lógico; si es TRUE, las probabilidades p se dan como log(p).",
      "Lógico; si es TRUE (por defecto), las probabilidades son $P[X \\leq x]$, de lo contrario, $P[X > x]$."
    )
  ),
  booktabs = TRUE,
  caption = "(ref:foo3)",
  escape = FALSE
) %>%
  kable_styling(
    bootstrap_options = "striped",
    full_width = FALSE,
    fixed_thead = T
  ) %>%
  kable_classic_2()
```

<table class="table table-striped lightable-classic-2" style='width: auto !important; margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
<caption>(\#tab:par-dist-normal)(ref:foo3)</caption>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> Parámetros </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> Descripción </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> x, q </td>
   <td style="text-align:left;"> Vector de cuantiles. </td>
  </tr>
  <tr>
   <td style="text-align:left;"> p </td>
   <td style="text-align:left;"> Vector de Probabilidades. </td>
  </tr>
  <tr>
   <td style="text-align:left;"> n </td>
   <td style="text-align:left;"> Número de observaciones. Si length(n) &gt; 1, se considera que la longitud es el número requerido. </td>
  </tr>
  <tr>
   <td style="text-align:left;"> mean </td>
   <td style="text-align:left;"> Vector de medias. </td>
  </tr>
  <tr>
   <td style="text-align:left;"> sd </td>
   <td style="text-align:left;"> Vector de desviaciones estándar. </td>
  </tr>
  <tr>
   <td style="text-align:left;"> log, log.p </td>
   <td style="text-align:left;"> Lógico; si es TRUE, las probabilidades p se dan como log(p). </td>
  </tr>
  <tr>
   <td style="text-align:left;"> lower.tail </td>
   <td style="text-align:left;"> Lógico; si es TRUE (por defecto), las probabilidades son $P[X \leq x]$, de lo contrario, $P[X > x]$. </td>
  </tr>
</tbody>
</table>
<br/>
La distribución base de <span style='color: blue;'>R</span> incluye la función `prop.test(x, n, p = NULL, alternative = c("two.sided", "less", "greater"), conf.level = 0.95, correct = TRUE)`, la cual permite calcular el $p_{valor}$ aproximado de la prueba binomial para muestra grandes. Los parámetros de esta función se especifican en la tabla \@ref(tab:par-prueba-binomial-aprox).

(ref:foo4) Descripción de los parámetros de la función `prop.test` de <span style='color: blue;'>R</span>


```{.r .watch-out}
knitr::kable(
  data.frame(
    stringsAsFactors = FALSE,
    Parámetros = c("x", "n", "p", "alternative", "conf.level", "correct"),
    Descripción = c(
      "Un vector de conteos de éxitos, una tabla unidimensional con dos entradas, o una tabla bidimensional (o matriz) con dos columnas, dando los conteos de éxitos y fracasos, respectivamente.",
      "Un vector de conteos de ensayos; ignorado si x es una matriz o una tabla.",
      "Un vector de probabilidades de éxito. La longitud de p debe ser igual al número de grupos especificados por x, y sus elementos deben ser mayores que 0 y menores que 1.",
      "Una cadena de caracteres que especifique la hipótesis alternativa, que puede ser: \"two.sided\" (por defecto), \"greater\" o \"less\". Puede especificar sólo la letra inicial. Sólo se utiliza para comprobar que una sola proporción es igual a un valor dado, o que dos proporciones son iguales; en caso contrario, se ignora.",
      "Nivel de confianza del intervalo de confianza establecido. Debe ser un solo número entre 0 y 1. Sólo se usa cuando se comprueba que una sola proporción es igual a un valor dado, o que dos proporciones son iguales; en caso contrario se ignora.",
      "Una indicación lógica de si la corrección de continuidad de Yates debe aplicarse siempre que sea posible."
    )
  ),
  booktabs = TRUE,
  caption = "(ref:foo4)",
  escape = FALSE
) %>%
  kable_styling(
    bootstrap_options = "striped",
    full_width = FALSE,
    fixed_thead = T
  ) %>%
  kable_classic_2()
```

<table class="table table-striped lightable-classic-2" style='width: auto !important; margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
<caption>(\#tab:par-prueba-binomial-aprox)(ref:foo4)</caption>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> Parámetros </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> Descripción </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> x </td>
   <td style="text-align:left;"> Un vector de conteos de éxitos, una tabla unidimensional con dos entradas, o una tabla bidimensional (o matriz) con dos columnas, dando los conteos de éxitos y fracasos, respectivamente. </td>
  </tr>
  <tr>
   <td style="text-align:left;"> n </td>
   <td style="text-align:left;"> Un vector de conteos de ensayos; ignorado si x es una matriz o una tabla. </td>
  </tr>
  <tr>
   <td style="text-align:left;"> p </td>
   <td style="text-align:left;"> Un vector de probabilidades de éxito. La longitud de p debe ser igual al número de grupos especificados por x, y sus elementos deben ser mayores que 0 y menores que 1. </td>
  </tr>
  <tr>
   <td style="text-align:left;"> alternative </td>
   <td style="text-align:left;"> Una cadena de caracteres que especifique la hipótesis alternativa, que puede ser: "two.sided" (por defecto), "greater" o "less". Puede especificar sólo la letra inicial. Sólo se utiliza para comprobar que una sola proporción es igual a un valor dado, o que dos proporciones son iguales; en caso contrario, se ignora. </td>
  </tr>
  <tr>
   <td style="text-align:left;"> conf.level </td>
   <td style="text-align:left;"> Nivel de confianza del intervalo de confianza establecido. Debe ser un solo número entre 0 y 1. Sólo se usa cuando se comprueba que una sola proporción es igual a un valor dado, o que dos proporciones son iguales; en caso contrario se ignora. </td>
  </tr>
  <tr>
   <td style="text-align:left;"> correct </td>
   <td style="text-align:left;"> Una indicación lógica de si la corrección de continuidad de Yates debe aplicarse siempre que sea posible. </td>
  </tr>
</tbody>
</table>
<br/>

### Implementación en <span style='color: blue;'>R</span> de la Prueba Binomial {#binomial1-R}

**Ejemplo 1**: En un estudio de los efectos del estrés, un investigador enseño a 18 estudiantes dos métodos diferentes para hacer el mismo nudo. La mitad de los sujetos (seleccionados aleatoriamente) aprendieron primero el método A y la otra mitad aprendió primero el método B. Posteriormente --a medianoche y después de un examen final de cuatro horas de duración--, a cada sujeto se le pidió que hiciera el nudo. La predicción fue que el estrés induciría regresión, esto es, que los sujetos regresarían al primer método aprendido para hacer el nudo. Cada sujeto fue categorizado conforme a si usó el primero o el segundo método aprendido de hacer nudos cuando se le pedía que hiciera el nudo bajo estrés. Resultando que 16 de los 18 utilizó el primer método aprendido para hacer el nudo. Este ejemplo es tomado de Sigel (1995, pág. 64).

En este ejemplo, la hipótesis alternativa que se quiere contrastar es que el estrés induce regresión en los estudiantes, es decir, que bajo estrés, la proporción de estudiantes que realiza el primer método aprendido para hacer el nudo es mayor que los que usan el segundo método aprendido $\left(H_1:p>\frac{1}{2}\right)$. Dicho de otra manera, bajo estrés, la proporción de estudiantes que deciden realizar el primer nudo aprendido es mayor que 0,5.

El siguiente código muestra la evaluación de la ecuación \@ref(eq:pus-binomial) usando la función `pbinom`, la cual evalúa la función de distribución acumulada binomial con parámetros $n=18$ y $p=0,5$, en $X=16-1=15$; es decir, $F\left(X=15, n=18,p=0,5\right)$.


```{.r .watch-out}
x <- 16
n <- 18
p0 <- 0.5
p.valor <- 1 - pbinom(q = x - 1, size = n, prob = p0)
paste("El p.valor = ", p.valor)
```

```{.bg-warning}
#> [1] "El p.valor =  0.0006561279296875"
```
<br/>

Como se puede ver en la salida generada por el código anterior, el $p_{valor}= 0,0007$ es menor que el nivel de significancia establecido ($\alpha = 0,05$), por lo que se concluye que el estrés produce regresión en los estudiantes, es decir, bajo estrés, la mayoría de los estudiantes deciden realizar el primer nudo aprendido.

El resultado anterior, también se puede obtener a través de la función `binom.test`, cuyos parámetros se describen en la tabla \@ref(tab:par-prueba-binom), a través del siguiente código:


```{.r .watch-out}
x <- 16
n <- 18
p0 <- 0.5
(ejemplo1 <- binom.test(
  x = x, n = n, p = p0, alternative = "greater",
  conf.level = 0.95
))
```

```{.bg-warning}
#> 
#> 	Exact binomial test
#> 
#> data:  x and n
#> number of successes = 16, number of trials = 18, p-value =
#> 0.0006561
#> alternative hypothesis: true probability of success is greater than 0.5
#> 95 percent confidence interval:
#>  0.6897373 1.0000000
#> sample estimates:
#> probability of success 
#>              0.8888889
```
<br/>

Como se nota en la salida, el $p_{valor}$ obtenido por este método es igual al obtenido por el procedimiento anterior.

Por otro lado, la aproximación asintótica del $p_{valor}$ indicado por la ecuación \@ref(eq:paproxus-binomial), se puede obtener con la ejecución del siguiente código.


```{.r .watch-out}
x <- 16
n <- 18
p0 <- 0.5
z <- (x - 0.5 - n * p0) / sqrt(n * p0 * (1 - p0))
(p.valor.aprox <- 1 - pnorm(q = z))
```

```{.bg-warning}
#> [1] 0.001091522
```
<br/>

Note que el $p_{valor \ aprox.} = 0,0011$ obtenida en la salida anterior, de igual manera, conduce a rechazar la hipótesis nula, dado que es menor que el nivel de significancia establecido. En este caso el $p_{valor \ aprox.} = 0,0011$ se considera una buena aproximación del $p_{valor}$ dado que $np = 9 > 5$.

También, la aproximación del $p_{valor}$ se puede obtener con la función `prop.test` del paquete `base`, como se muestra a continuación, con el siguiente código.


```{.r .watch-out}
prop.test(
  x = 16, n = 18, p = 0.5, alternative = "greater",
  conf.level = 0.95, correct = TRUE
)
```

```{.bg-warning}
#> 
#> 	1-sample proportions test with continuity correction
#> 
#> data:  16 out of 18, null probability 0.5
#> X-squared = 9.3889, df = 1, p-value = 0.001092
#> alternative hypothesis: true p is greater than 0.5
#> 95 percent confidence interval:
#>  0.6803061 1.0000000
#> sample estimates:
#>         p 
#> 0.8888889
```
<br/>

Note que la aproximación del $p_{valor}$ obtenida en estas dos últimas salidas son iguales.

### Problemas Propuestos {#broblemas-binomial1}

1)  En una población de personas con edades entre 15 y 19 años, se encontró que $6,9\%$ son positivas a una determinada enfermedad. Supongamos que una muestra aleatoria de 25 de ellas son seleccionadas y que 4 resultaron positivas.
    a)  ¿Poseen los datos suficiente evidencias para indicar que la proporción de positivas en esta población es mayor de $7\%$? (Use $\alpha = 5\%$).
    b)  ¿Qué pasa si en vez de tomar la muestra aleatoria de 25, se toma una muestra aleatoria de 30? (Use $\alpha = 5\%$).

2)  Un fabricante afirma que el $5\%$ de sus computadores pueden estar defectuosos. Un comprador recibe 20 computadores de los cuales 3 están defectuosos.
    a)  ¿Poseen los datos suficiente evidencias para indicar que la proporción de computadoras defectuosas en esta población es menor de $5\%$? (Use $\alpha = 5\%$).
    b)  ¿Qué pasa si en vez de tomar la muestra aleatoria de 20, se toma una muestra aleatoria de 30? (Use $\alpha = 5\%$).


## Prueba del Signo {#signo1}

La *prueba del signo* es un test no paramétrico que se usa para contrastar hipótesis referentes a la mediana de una población. La aplicación de este test requiere que la variable analizada sea continua.

### Racionalización de la Prueba del Signo {#racionalizacion-signo1}

Supóngase que se tiene una variable aleatoria continua $X$ con función de distribución de probabilidad acumulada o simplemente distribución de probabilidad F(x) desconocida. Y que se quiere contrastar la hipótesis nula de que la mediana de $X$ es $\widetilde{\mu}_{0}$, es decir, $H_{0}:\widetilde{\mu}= \widetilde{\mu}_{0}$. Si la hipótesis nula es verdadera, la probabilidad de que cualquier valor de $X$ sea menor o igual que la mediana $\widetilde{\mu}_{0}$ es $\frac{1}{2}$, esto es, $P \left(X< \widetilde{\mu}_{0}\right)=\frac{1}{2}$. Por complemento, la probabilidad de que cualquier valor de $X$ sea mayor o igual que la mediana también es $\frac{1}{2}$, es decir, $P \left(X\geq \widetilde{\mu}_{0}\right)=1-P \left(X\leq \widetilde{\mu}_{0}\right)=1-F \left(\widetilde{\mu}_{0} \right)=\frac{1}{2}$. Sea $X_1,X_2,\dotsc,X_n$ una muestra de tamaño $n$ de $X$, tal que $X_i$ representa el $i-ésimo$ valor de $X$ observado en la muestra, para $i=1,2,\dotsc,n$. Está claro que los $X_i$ son variables aleatorias independientes con la misma distribución de $X$, es decir $F(x)=F\left(x_i \right)$. Si se define la siguiente variable aleatoria que toma el valor 1, si el $i-ésimo$ valor muestral es mayor que la mediana y 0 si es menor, lo que se puede expresar de la siguiente manera:

$$
D_{i}=\begin{cases}
1, \ \text{ si } X_i> \widetilde{\mu}_0\\
0, \ \text{ si } X_i< \widetilde{\mu}_0 
\end{cases}
$$

De lo anterior se deduce que la probabilidad de encontrar cualquier valor en la muestra que esté por encima de la mediana $\widetilde{\mu}_0$, de manera teórica, es:

$$
P\left(D_i=1 \right)=P \left(X> \widetilde{\mu}_{0}\right)=1-P \left(X\leq \widetilde{\mu}_{0}\right)=1-F \left(\widetilde{\mu}_{0} \right)=\frac{1}{2}.
$$

Mientras que, por complemento, la probabilidad de encontrar un valor cualquiera en la muestra que esté por debajo de la mediana $\widetilde{\mu}_{0}$ es:

$$
P\left(D_i=0 \right)=P \left(X< \widetilde{\mu}_{0}\right)=P \left(X\leq \widetilde{\mu}_{0}\right)=F \left(\widetilde{\mu}_{0} \right)=\frac{1}{2}.
$$

Note que los $D_i$ constituyen $n$ réplicas independientes de un experimento de Bernoulli con probabilidad de éxito $p=P(D_i=1)=\frac{1}{2}$. Ahora, sea $S$ la variable aleatoria que representa el número de valores muestrales que se encuentran por encima de la mediana propuesta bajo la hipótesis nula $\widetilde{\mu}_{0}$. Esto es:

$$
\begin{equation}
S=\sum_{i=1}^{n}D_i.
\end{equation}
(\#eq:estadistico-signo)
$$

Dado que la probabilidad de que cualquier valor en la muestra se encuentre por encima de la mediana $\widetilde{\mu}_{0}$ es $\frac{1}{2}$, y que los $D_i$ representan $n$ réplicas independientes de un experimento de Bernoulli, entonces $S$ es una variable aleatoria binomial con parámetros $n$ y $p=\frac{1}{2}$. Por lo tanto su media es $np=\frac{n}{2}$ y su varianza es $npq=\frac{n}{4}$. Teóricamente hablando, dado que $X$ es una variable aleatoria continua, es imposible encontrar en la muestra un $X_i=\widetilde{\mu}_{0}$, debido a que $P \left(X=\widetilde{\mu}_{0} \right)= 0$, por ser $X$ una variable continua. Pero en la práctica esto frecuentemente ocurre, debido generalmente a imprecisión en el instrumento que se ha usado para medir $X$. Por tal motivo, cuando en la muestra ocurren valores muestrales iguales a la mediana $\widetilde{\mu}_{0}$, estos deben ser eliminados y el tamaño de la muestra se redefine como el número de observaciones en la muestra para las cuales $X_i \neq \widetilde{\mu}_{0}$. Como se dijo anteriormente, bajo la hipótesis nula, $S\sim B\left ( n, p=\frac{1}{2} \right )$, por lo tanto la probabilidad de encontrar de manera exacta $s$ observaciones en una muestra en particular por encima de $\widetilde{\mu}_{0}$ (éxitos), viene dada, haciendo $p=\frac{1}{2}$ en la ecuación \@ref(eq:fmp-binomial), por:

$$
\begin{equation}
P\left ( S=s \right )=p _{B} \left(s, \ n, \ p = \frac{1}{2} \right)= \frac{1}{2^{n}}\binom{n}{s}, \ s = 0, 1, \dotsc, n, \ n>0 \ y \ p =\frac{1}{2}.
(\#eq:fmp-signo)
\end{equation}
$$

Mientras que la probabilidad de obtener a lo más $s$ observaciones por encima de $\widetilde{\mu}_{0}$, se obtiene sustituyendo en la ecuación \@ref(eq:fdp-binomial) $p$ por $\frac{1}{2}$, es decir:

$$
\begin{equation}
P(S\leq s)=F_{B}\left (s, \ n, \ p=\frac{1}{2} \right )=\frac{1}{2^{n}}\sum_{i=0}^{s}\binom{n}{i}, \ s=0, 1, \dotsc, n, \ n > 0 \ y \ p=\frac{1}{2}. 
(\#eq:fdp-signo)
\end{equation}
$$

Fíjese que probar la hipótesis nula $H_{0}:\widetilde{\mu}= \widetilde{\mu}_{0}$ es equivalente a probar la hipótesis nula de que la proporción de posibles valores de $X$ por encima de $\widetilde{\mu}_{0}$ es igual a $\frac{1}{2}$, es decir, $H_{0}:p= \frac{1}{2}$. En tal sentido, la prueba del signo puede considerarse como un caso particular de la prueba binomial cuando $p_0=\frac{1}{2}$. Para contrastar la hipótesis nula referente a la proporción se usa el estadístico de prueba S, el cual, bajo la hipótesis nula $H_{0}:\widetilde{\mu}= \widetilde{\mu}_{0}$, se distribuye binomialmente con parámetros $n$ y $p=\frac{1}{2}$, por lo que su media es $\frac{n}{2}$ y su varianza es $\frac{n}{4}$. Ahora, si $s$ es un valor de $S$ obtenido a partir de una muestra de $X$, un valor de $s$ muy alejado de $\frac{n}{2}$ (por arriba o por debajo), sería evidencia de que $p \neq \frac{1}{2}$ y en consecuencia $\widetilde{\mu} \neq \widetilde{\mu}_{0}$.

En este orden de ideas, suponga que se quiere probar la hipótesis alternativa unilateral superior $H_{1}:\widetilde{\mu}> \widetilde{\mu}_{0}$, lo que sería equivalente a probar la hipótesis alternativa para la proporción $H_1: p> \frac{1}{2}$, que de acuerdo a la ecuación \@ref(eq:pus-binomial), el p.valor sería:

$$
\begin{equation}
p_{valor}=1-F_{B}\left ( s-1, \ n, \ p=\frac{1}{2} \right )=1- \frac{1}{2^{n}} \sum_{i=0}^{s-1}\binom{n}{i}.
(\#eq:pus-signo)
\end{equation}
$$

En caso de que la hipótesis alternativa para la mediana fuera unilateral inferior $H_{1}:\widetilde{\mu}< \widetilde{\mu}_{0}$, su hipótesis equivalente para la proporción sería $H_1: p < \frac{1}{2}$. En tal sentido, de la ecuación \@ref(eq:pui-binomial), el $p_{valor}$ para este caso sería,

$$
\begin{equation}
p_{valor}=F_{B}\left (s, \ n, \ p=\frac{1}{2} \right )= \frac{1}{2^{n}} \sum_{i=0}^{s}\binom{n}{i}.
(\#eq:pui-signo)
\end{equation}
$$

Para los casos en los que la hipótesis alternativa es unilateral el criterio de decisión consiste en aceptar $H_{1}$ si el $p_{valor}< \alpha$ se acepta H_1, ya sea que esta haya sido planteado en forma unilateral superior $\left(H_{1}:\widetilde{\mu}> \widetilde{\mu}_{0}\right)$ o unilateral inferior $\left(H_{1}:\widetilde{\mu}< \widetilde{\mu}_{0}\right)$.

Para una hipótesis alternativa de dos colas $H_{1}:\widetilde{\mu}\neq \widetilde{\mu}_{0}$, su correspondiente en términos de proporción sería $H_1: p \neq \frac{1}{2}$ , por lo que de la ecuación \@ref(eq:pbl-binomial), su $p_{valor}$ sería:

$$
\begin{equation}
p_{valor}=
\begin{cases} 
2\left [ 1-F_{B}\left ( s-1,\ n,\ p = \frac{1}{2} \right ) \right ], \ \textit{si} \ s > \frac{n}{2} \\ 
2F_{B}\left ( s,\ n, \ p = \frac{1}{2} \right ), \ \textit{si} \ s \leq \frac{n}{2} 
 \end{cases}.
(\#eq:pbl-signo)
\end{equation}
$$

<span style='color: blue;'>R</span> proporciona la función `SIGN.test(x, y = NULL, md = 0, alternative = "two.sided", conf.level = 0.95, \dotsc)` disponible en el paquete `BSDA` que permite ejecutar la prueba del signo para una muestra (desarrollada acá) y dos muestras relacionadas (tratada en el siguiente núcleo temático). Los parámetros de esta función se definen en la tabla \@ref(tab:par-prueba-signo).

(ref:foo5) Descripción de los parámetros de la función `SIGN.test` de <span style='color: blue;'>R</span>


```{.r .watch-out}
knitr::kable(
  data.frame(
    stringsAsFactors = FALSE,
    Parámetros = c("x", "y", "md", "alternative", "conf.level", "…"),
    Descripción = c(
      "Vector numérico; los NA e Inf están permitidos pero serán eliminados.",
      "Vector numérico opcional; los NA e Inf están permitidos pero serán eliminados.",
      "Un número único que represente el valor de la mediana de la población especificada por la hipótesis nula.",
      "Es una cadena de caracteres, que puede tomar el valor: \"greater\", \"less\" o \"two.sided\", o la letra inicial de cada una de ellas, que indica la hipótesis alternativa especificada. Para pruebas de una muestra, alternative se refiere a la verdadera mediana de la población originaria en relación con el valor hipotético de la mediana.",
      "Nivel de confianza para el intervalo de confianza establecido, limitado a estar entre cero y uno.",
      "Otros argumentos que se deben proporcionar a o desde los métodos."
    )
  ),
  booktabs = TRUE,
  caption = "(ref:foo5)",
  escape = FALSE
) %>%
  kable_styling(
    bootstrap_options = "striped",
    full_width = FALSE,
    fixed_thead = T
  ) %>%
  kable_classic_2()
```

<table class="table table-striped lightable-classic-2" style='width: auto !important; margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
<caption>(\#tab:par-prueba-signo)(ref:foo5)</caption>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> Parámetros </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> Descripción </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> x </td>
   <td style="text-align:left;"> Vector numérico; los NA e Inf están permitidos pero serán eliminados. </td>
  </tr>
  <tr>
   <td style="text-align:left;"> y </td>
   <td style="text-align:left;"> Vector numérico opcional; los NA e Inf están permitidos pero serán eliminados. </td>
  </tr>
  <tr>
   <td style="text-align:left;"> md </td>
   <td style="text-align:left;"> Un número único que represente el valor de la mediana de la población especificada por la hipótesis nula. </td>
  </tr>
  <tr>
   <td style="text-align:left;"> alternative </td>
   <td style="text-align:left;"> Es una cadena de caracteres, que puede tomar el valor: "greater", "less" o "two.sided", o la letra inicial de cada una de ellas, que indica la hipótesis alternativa especificada. Para pruebas de una muestra, alternative se refiere a la verdadera mediana de la población originaria en relación con el valor hipotético de la mediana. </td>
  </tr>
  <tr>
   <td style="text-align:left;"> conf.level </td>
   <td style="text-align:left;"> Nivel de confianza para el intervalo de confianza establecido, limitado a estar entre cero y uno. </td>
  </tr>
  <tr>
   <td style="text-align:left;"> … </td>
   <td style="text-align:left;"> Otros argumentos que se deben proporcionar a o desde los métodos. </td>
  </tr>
</tbody>
</table>
<br/>

De manera análoga a la prueba binomial, cuando el tamaño de la muestra es grande la distribución del estadístico de prueba $S$ tiende a la normal conforme $n$ tiende a infinito, en este caso la convergencia es rápida dado que para $p=\frac{1}{2}$ la distribución binomial es simétrica, por tanto, valores conservadores de $n$ garantizan una buena aproximación. Luego, dado que bajo la hipótesis nula $p_{0}=\frac{1}{2}$ y haciendo la sustitución respectiva en la ecuación \@ref(eq:z-binomial), el estadístico $Z$, queda definido como:

$$
\begin{equation}
Z=\frac{2S-n}{\sqrt{n}}.
(\#eq:z-signo)
\end{equation}
$$

Dado que $Z$ es una estandarización de $S$, entonces $Z\simeq N\left(\mu_{Z}=0, \sigma_{Z}=1\right)$ para un $n$ suficientemente grande. Ahora, tal como se aplicó corrección por continuidad de Yate para conseguir mejores aproximaciones en el cálculo de probabilidades en la prueba binomial dada por la ecuación \@ref(eq:zcorr-binomial), del mismo modo, mejores aproximaciones del $p_{valor}$ en la prueba del signo se obtienen con el estadístico:

$$
\begin{equation}
Z=\frac{\left(2S \pm 1 \right)-n}{\sqrt{n}},
(\#eq:zcorr-signo)
\end{equation}
$$

Donde $2S + 1$ se usa cuando $S < \frac{n}{2}$ y $2S - 1$ se usa cuando$S > \frac{n}{2}$.

En este orden de ideas, un valor aproximado del $p_{valor}$ cuando la hipótesis alternativa es unilateral superior $\left(H_{1}:\widetilde{\mu}> \widetilde{\mu}_{0}\right)$), se obtiene sustituyendo en la ecuación \@ref(eq:paproxus-binomial) $p_{0}$ por $\frac{1}{2}$. El resultado se presenta en la siguiente ecuación:

$$
\begin{equation}
p_{valor}\cong 1-F_{N}\left ( Z= \frac{2s-1-n}{\sqrt{n}}, \ \mu_{Z}=0, \ \sigma_{Z}=1 \right ).
(\#eq:paproxus-signo)
\end{equation}
$$

De manera análoga, cuando la hipótesis alternativa es unilateral inferior $\left(H_{1}:\widetilde{\mu}< \widetilde{\mu}_{0}\right)$, el $p-{valor}$ aproximado se obtiene reemplazando en la ecuación \@ref(eq:paproxui-binomial) $p_{0}$ por $\frac{1}{2}$, como sigue:

$$
\begin{equation}
p_{valor}\cong F_{N}\left ( Z= \frac{2s+1-n}{\sqrt{n}}, \ \mu_{Z}=0, \ \sigma_{Z}=1 \right ).
(\#eq:paproxui-signo)
\end{equation}
$$

Del mismo modo, cuando la prueba de hipótesis es a dos colas o bilateral $\left(H_{1}:\widetilde{\mu}\neq \widetilde{\mu}_{0}\right)$, el $p_{valor}$ aproximado se obtiene sustituyendo en la ecuación \@ref(eq:paproxbl-binomial) $p_{0}$ por $\frac{1}{2}$, como sigue:

$$
\begin{equation}
p_{valor}\cong \begin{cases}
2\left [ 1-F_{N}\left ( Z=\frac{2s-1-n}{\sqrt{n}},  \ \mu_{Z}=0, \ \sigma_{Z}=1\right ) \right ] , \ \textit{si} \ s> \frac{n}{2} \\ 
2 F_{N}\left ( Z= \frac{2s+1-n}{\sqrt{n}} ,\ \mu_{Z}=0, \ \sigma_{Z}=1\right ), \ \textit{si} \ s \leq \frac{n}{2} 
\end{cases}. 
(\#eq:paproxbl-signo)
\end{equation}
$$

<span style='color: blue;'>R</span> proporciona la función `SIGN.test(x, y = NULL, md = 0, alternative = "two.sided", conf.level = 0.95, \dotsc)` disponible en el paquete `BSDA` que permite ejecutar la prueba del signo para una muestra (desarrollada acá) y dos muestras relacionadas (tratada en el siguiente núcleo temático). Los parámetros de esta función se definen en la siguiente tabla.

### Implementación en <span style='color: blue;'>R</span> de la Prueba del Signo {#signo1-R}

**Ejemplo 2**: Los siguientes datos constituyen una muestra aleatoria de 15 mediciones de la clasificación de octano de cierto tipo de gasolina:

$$
\begin{array}{cccccccc}
\hline
99,0 &  102,3 & 99,8 &  100,5 & 99,7 &  96,2 &  99,1 &  102,5 \\
103,3 & 97,4 &  100,4 & 98,9 &  98,3 &  98,0 &  101,6 & \\
\hline
\end{array}
$$

Pruebe la hipótesis nula $\widetilde{\mu}=98,0$ contra la hipótesis alternativa $\widetilde{\mu}> 98,0$ en el nivel de significancia 0,01. Este ejemplo es tomado de Johnson (2012, pág. 460).

Para contrastar estas hipótesis primero es conveniente ordenar la muestra de mayor a menor y luego asignar a cada observación un signo positivo ("+"), igual ("=") o negativo ("-") según sea mayor, igual o menor que la mediana, respectivamente. Tal como se muestra en la tabla \@ref(tab:datos2).


```{.r .watch-out}
co <- c(
  99.0, 102.3, 99.8, 100.5, 99.7, 96.2, 99.1, 102.5,
  103.3, 97.4, 100.4, 98.9, 98.3, 98.0, 101.6
)
mediana <- 98
alfa <- 0.01
datos2 <- tibble(
  observacion = 1:length(co),
  co = co
) %>%
  mutate(
    signo = as.factor(
      case_when(
        co > mediana ~ "\\+",
        co == mediana ~ "=",
        co < mediana ~ "\\-"
      )
    )
  ) %>%
  arrange(co)
kableExtra::kbl(
  datos2,
  col.names = c("Observación", "Clasificación de octano", "Signo"),
  format.args = list(decimal.mark = ",", big.mark = "."),
  booktabs = TRUE,
  caption = "\\label{tab2:datos2}Clasificación de octano de cierto tipo de gasolina",
  escape = FALSE
) %>%
  kable_styling(
    bootstrap_options = "striped",
    full_width = FALSE,
    fixed_thead = T
  ) %>%
  row_spec(which(datos2$signo == "="), color = "red", strikeout = T) %>%
  kable_classic_2() %>%
  scroll_box(width = "100%", height = "400px")
```

<div style="border: 1px solid #ddd; padding: 0px; overflow-y: scroll; height:400px; overflow-x: scroll; width:100%; "><table class="table table-striped lightable-classic-2" style='width: auto !important; margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
<caption>(\#tab:datos2)\label{tab2:datos2}Clasificación de octano de cierto tipo de gasolina</caption>
 <thead>
  <tr>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;position: sticky; top:0; background-color: #FFFFFF;"> Observación </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;position: sticky; top:0; background-color: #FFFFFF;"> Clasificación de octano </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;position: sticky; top:0; background-color: #FFFFFF;"> Signo </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 96,2 </td>
   <td style="text-align:left;"> \- </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 97,4 </td>
   <td style="text-align:left;"> \- </td>
  </tr>
  <tr>
   <td style="text-align:right;text-decoration: line-through;color: red !important;"> 14 </td>
   <td style="text-align:right;text-decoration: line-through;color: red !important;"> 98,0 </td>
   <td style="text-align:left;text-decoration: line-through;color: red !important;"> = </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 13 </td>
   <td style="text-align:right;"> 98,3 </td>
   <td style="text-align:left;"> \+ </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 12 </td>
   <td style="text-align:right;"> 98,9 </td>
   <td style="text-align:left;"> \+ </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 99,0 </td>
   <td style="text-align:left;"> \+ </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 99,1 </td>
   <td style="text-align:left;"> \+ </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 99,7 </td>
   <td style="text-align:left;"> \+ </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 99,8 </td>
   <td style="text-align:left;"> \+ </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 11 </td>
   <td style="text-align:right;"> 100,4 </td>
   <td style="text-align:left;"> \+ </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 100,5 </td>
   <td style="text-align:left;"> \+ </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 15 </td>
   <td style="text-align:right;"> 101,6 </td>
   <td style="text-align:left;"> \+ </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 102,3 </td>
   <td style="text-align:left;"> \+ </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 102,5 </td>
   <td style="text-align:left;"> \+ </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:right;"> 103,3 </td>
   <td style="text-align:left;"> \+ </td>
  </tr>
</tbody>
</table></div>
<br/>

Note que en la tabla \@ref(tab:datos2) la observación 14 es igual que la mediana establecida en la hipótesis nula, por lo que esta observación se elimina de la muestra y $n$ se establece como 14. La tabla anterior se resume en la tabla \@ref(tab:conteo-signos), ejecutando el siguiente código.


```{.r .watch-out}
conteo_signo <- datos2 %>%
  group_by(signo) %>%
  summarise(conteo = n())
kable(
  x = conteo_signo,
  col.names = c("Signo", "Conteo"),
  format.args = list(decimal.mark = ",", big.mark = "."),
  booktabs = TRUE,
  caption = "\\label{tab2:datos2}Conteo de signos",
  escape = FALSE
) %>%
  kable_styling(
    bootstrap_options = "striped",
    full_width = FALSE,
    fixed_thead = T
  ) %>%
  kable_classic_2()
```

<table class="table table-striped lightable-classic-2" style='width: auto !important; margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
<caption>(\#tab:conteo-signos)\label{tab2:datos2}Conteo de signos</caption>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> Signo </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> Conteo </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> \- </td>
   <td style="text-align:right;"> 2 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> \+ </td>
   <td style="text-align:right;"> 12 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> = </td>
   <td style="text-align:right;"> 1 </td>
  </tr>
</tbody>
</table>
<br/>

La hipótesis alternativa que se pretende contrastar es unilateral superior $H_{1}:\widetilde{\mu}> 98,0$. Para este caso el valor del estadístico de prueba $s$ y el $p_{valor}$ vienen dados por las ecuaciones \@ref(eq:estadistico-signo) y \@ref(eq:pus-signo). El siguiente código permite determinar el valor del estadístico de prueba $s$ y el $p_{valor}$, necesarios para contrastar la hipótesis planteada.


```{.r .watch-out}
s <- as.numeric(conteo_signo %>%
  dplyr::filter(signo == "\\+") %>%
  dplyr::select(conteo))
n <- as.numeric(conteo_signo %>%
  dplyr::filter(signo != "=") %>%
  dplyr::select(conteo) %>%
  sum())
p.valor <- 1 - pbinom(q = s - 1, size = n, prob = 0.5)
paste("El estadístico de prueba  s =", s, "y el p.valor =", p.valor)
```

```{.bg-warning}
#> [1] "El estadístico de prueba  s = 12 y el p.valor = 0.0064697265625"
```
<br/>

En la salida anterior se observa que el valor del estadístico de prueba $s=12$ , mientras que el $p_{valor} = 0,0065$ . De donde se concluye que existe suficiente evidencia estadística para asegurar que la mediana de la clasificación de octano del combustible es mayor que 98, debido a que el $p_{valor}$ es menor que el nivel de significancia especificado ($\alpha =$ 0,01).

Una forma más expedita de ejecutar la prueba del signo en <span style='color: blue;'>R</span> es a través de la función `SING.test` del paquete `BSDA` cuyos parámetros se describen en la tabla \@ref(tab:par-prueba-signo). El siguiente código muestra la ejecución de la prueba del signo por medio de esta función. Note que el $p_{valor}$ que se muestra en esta salida es igual al obtenido en la salida anterior.


```{.r .watch-out}
BSDA::SIGN.test(x = co, md = 98, alternative = "g", conf.level = 0.99)
```

```{.bg-warning}
#> 
#> 	One-sample Sign-Test
#> 
#> data:  co
#> s = 12, p-value = 0.00647
#> alternative hypothesis: true median is greater than 98
#> 99 percent confidence interval:
#>  98.13627      Inf
#> sample estimates:
#> median of x 
#>        99.7 
#> 
#> Achieved and Interpolated Confidence Intervals: 
#> 
#>                   Conf.Level  L.E.pt U.E.pt
#> Lower Achieved CI     0.9824 98.3000    Inf
#> Interpolated CI       0.9900 98.1363    Inf
#> Upper Achieved CI     0.9963 98.0000    Inf
```
<br/>

Dado que la prueba del signo se puede considerar como un caso particular de la prueba binomial cuando $p_{0}=\frac{1}{2}$, la función `binom.test` también puede ser usada para realizar la prueba del signo. El siguiente código muestra la ejecución de la prueba del signo a través de esta función. Note que el $p_{valor}$ obtenido aquí es idénticos a los anteriores.


```{.r .watch-out}
s <- as.numeric(conteo_signo %>%
  dplyr::filter(signo == "\\+") %>%
  dplyr::select(conteo)) # se ha colocado dplyr::select para
n <- as.numeric(conteo_signo %>% # evitar conflicto con MASS::select
  dplyr::filter(signo != "=") %>%
  dplyr::select(conteo) %>% sum())
binom.test(
  x = s, n = n, p = 0.5, alternative = "greater",
  conf.level = 0.99
)
```

```{.bg-warning}
#> 
#> 	Exact binomial test
#> 
#> data:  s and n
#> number of successes = 12, number of trials = 14, p-value =
#> 0.00647
#> alternative hypothesis: true probability of success is greater than 0.5
#> 99 percent confidence interval:
#>  0.5217357 1.0000000
#> sample estimates:
#> probability of success 
#>              0.8571429
```
<br/>

Como se dijo anteriormente, el $p_{valor}$ para la prueba del signo, cuando $n$ es suficientemente grande, se puede aproximar con la ecuación \@ref(eq:paproxus-signo). El siguiente código permite evaluar tal ecuación. Como se puede ver, el $p_{valor \ aprox.}$ generado por este procedimiento $\left(0,0081\right)$ no difiere mucho del $p_{valor}$ exacto $\left(0,0065\right)$ obtenido por los métodos anteriores. Note que el $p_{valor \ aprox.}$ sigue siendo menor que el nivel de significancia establecido para esta prueba, lo que conduce, de igual manera, a rechazar la hipótesis nula $H_{0}: \widetilde{\mu}=98,0$.


```{.r .watch-out}
s <- as.numeric(conteo_signo %>%
  dplyr::filter(signo == "\\+") %>%
  dplyr::select(conteo))
n <- as.numeric(conteo_signo %>%
  dplyr::filter(signo != "=") %>%
  dplyr::select(conteo) %>%
  sum())
p.valor.aprox <- 1 - pnorm(q = (2 * s - 1 - n) / sqrt(n))
paste(
  "El p.valor.aprox = ",
  format(
    x = p.valor.aprox,
    decimal.mark = getOption("OutDec")
  )
)
```

```{.bg-warning}
#> [1] "El p.valor.aprox =  0.008078466"
```
<br/>

Otra manera de calcular el $p_{valor \ aprox.}$ es usando la función `prop.test`, de manera análoga a la prueba binomial.


```{.r .watch-out}
s <- as.numeric(conteo_signo %>%
  dplyr::filter(signo == "\\+") %>%
  dplyr::select(conteo))
n <- as.numeric(conteo_signo %>%
  dplyr::filter(signo != "=") %>%
  dplyr::select(conteo) %>%
  sum())
prop.test(
  x = s, n = n, p = 0.5, alternative = "greater",
  conf.level = 0.99, correct = TRUE
)
```

```{.bg-warning}
#> 
#> 	1-sample proportions test with continuity correction
#> 
#> data:  s out of n, null probability 0.5
#> X-squared = 5.7857, df = 1, p-value = 0.008078
#> alternative hypothesis: true p is greater than 0.5
#> 99 percent confidence interval:
#>  0.5106275 1.0000000
#> sample estimates:
#>         p 
#> 0.8571429
```
<br/>

### Problemas Propuestos {#broblemas-signo1}

1)  Se toman 10 muestras de un baño de cultivo sobre placa utilizado en un proceso de fabricación de componentes electrónicos, y se mide el pH del baño. Los valores de pH medidos son 7,91; 7,85; 6,82; 8,01; 7,46; 6,95; 7,05; 7,35; 7,25; 7,42. Los ingenieros plantean que el pH neutro es 7. ¿La muestra indica que esta proposición es correcta? Use $\alpha = 5\%$.

2)  Los siguientes datos representan el número de horas que un temporizador opera antes de que deba recargarse: 1,5; 2,2; 0,9; 1,3; 2,0; 1,6; 1,8; 1,5; 2,0; 1,2 y 1,7. Utiliza la prueba de los signos para probar la hipótesis al nivel de significancia de 0,05 que este temporizador en particular opera con una mediana de 1,8 horas antes de requerir una recarga.

## Prueba de Bondad de Ajuste Ji-cuadrado {#jicuadrado1}

La prueba Ji-cuadrado de bondad de ajuste se usa para contrastar la hipótesis de que una variable aleatoria tiene una determinada distribución de probabilidad. Para ello la variable aleatoria debe ser categórica, discreta o continua (preferiblemente categórica o discreta). En este último caso la variable aleatoria debe ser categorizada, para ello el recorrido de la variable debe ser particionado en $k$ intervalos (construir tabla de distribución de frecuencia en intervalos de clases).

### Racionalización de la Prueba de Bondad de Ajuste Ji-cuadrado {#racionalizacion-jicuadrado1}

Sea $X$ una variable aleatoria con distribución de probabilidad $F\left(x,\theta\right)$, donde $\theta=\left(\theta_1, \dotsc, \theta_r\right)$ es un vector de dimensión $r$ que define los parámetros de la distribución; si $\left(x_1,\dotsc, x_n \right)$ es una m.a.s. de $X$; entonces la prueba de bondad de ajuste Ji-cuadrado permite contrastar, a la luz de la información de la muestra, si la distribución de $X$ es la indicada en la hipótesis nula $\left(H_0: F(x,\theta)=F(x,\theta_0 )\right)$. Se van a distinguir dos casos, según que $F$ sea perfectamente conocida, es decir, el vector de parámetros bajo la hipótesis nula, $\theta_0=\left(\theta_{10}, \dotsc, \theta_{r0} \right)$, es conocido por ejemplo viene dada por la normal de media 0 y de desviación típica 1, o bien que $F$ sea conocida pero se desconozca $\theta_0$, en tal caso $\theta_0$ debe ser estimado con la información de la muestra; por ejemplo, que $F$ venga dada por la normal de media $\mu$ y de desviación típica $\sigma$ desconocidas, en esta situación $\mu$ y $\sigma$ deberán ser estimados con la información muestral.

En el primer caso, suponga que $I$ define el recorrido de la población $X$ y que $I$ se ha dividido en $k$ intervalos mutuamente excluyentes y colectivamente exhaustivos, en principio en forma arbitraria, $I_1, \dotsc, I_k$ con lo que es posible calcular bajo la hipótesis nula las probabilidades $p_{i0}=P\left\{x\in I_i\right\}$, para $i = 1, \dotsc, k$.

Si la muestra es compatible con $F\left(x,\theta_0 \right)$ se puede suponer la hipótesis nula $H_0:$ consistente en que el vector $(n_1, \dotsc, n_k )$, con $n_i$ número de veces que en la muestra aparece un elemento del intervalo $I_i$, tiene una distribución $\left (N_{1} = n_{1}, \dotsc, N_{k} = n_{k} \right )\sim \textit{Multinomial}\left ( n, p_{10}, \dotsc, p_{k0} \right )$, frente a la hipótesis alternativa $H_1:\left (N_{1} = n_{1}, \dotsc, N_{k} = n_{k} \right )\sim \textit{Multinomial}\left ( n, p_{1}, \dotsc, p_{k} \right )$ . La única diferencia está en que bajo la hipótesis nula los parámetros de la distribución multinomial $p_0 =(p_{10},\dotsc,p_{k0})$ son conocidos, mientras que bajo la hipótesis alternativa los parámetros $p = (p_1,\dotsc,p_k )$ son desconocidos.

Si se emplea el contraste de la razón de verosimilitudes, se tiene que

$$
\lambda\left ( n_{1}, \dotsc, n_{k} \right ) =\frac{\frac{n!}{n_1! \dotsm n_k!}\left ( p_{10} \right )^{n_1} \dotsm \left ( p_{k0} \right )^{n_k}}{\underset{p_1, \dotsc, p_k}{SUP}\frac{n!}{n_1! \dotsm n_k!}\left ( p_1 \right )^{n_1} \dotsm \left ( p_k \right )^{n_k}}.
$$

El supremo del denominador, asumiendo que $\sum_{i=1}^{k}p_i=1$, se alcanza en $\widehat{p}_i=\frac{n_i}{n}$, dado que estos son los estimadores de máxima verosimilitud de los $p_i$. Por tanto, la región crítica será de la forma

$$
RC=\left\{\lambda \left ( n_1, \dotsc, n_k \right ) = \prod_{i=1}^{k} \left ( \frac{p_{i0}}{\widehat{p}_i} \right )^{n_i} \leq k \right\}.
$$

Bajo $H_0$ la distribución asintótica de $-2\ln\lambda(n_1, \dotsc, n_k )$ es una $\chi^{2}$ con $k-1$ grados de libertad, ya que, $H_0∪H_1$ tiene de dimensión $k-1$ y la hipótesis nula tiene de dimensión 0. Para un tamaño $\alpha$, se obtiene la región crítica

$$
RC = \left\{-2 \ln \lambda \left ( n_1, \dotsc, n_k \right )=-2\sum_{i=1}^{k}n_i \left [ \ln p_{i0}- \ln\widehat{p}_i\right ]\geq \chi ^{2}_{k-1};1-\alpha \right\}.    
$$

K. Pearson introdujo un procedimiento alternativo de resolver el problema, mediante una distancia ponderada entre el $EMV$ del vector multinomial $\widehat{p}$ y el valor $p_0$ supuesto bajo la hipótesis nula, en concreto la cantidad

$$
D^{2}  \left ( p_0, \widehat{p} \right ) = \sum_{i=1}^{k}\lambda_i\left ( \widehat{p}_i -p_{i0} \right )^{2}
$$

con

$$
\lambda_i=\frac{n}{n_i}
$$

y rechazar la hipótesis nula para valores grandes de la distancia; por lo que la región crítica es

$$
RC=\left\{ \sum_{i=1}^{k}\frac{\left ( n_i - np_{i0} \right )^{2}}{np_{i0}}\geq c\right\}
$$

Con el fin de poder determinar la constante $c$ para que el contraste tenga un nivel de significancia de tamaño $\alpha$, es necesario conocer la distribución de la cantidad

$$
\sum_{i=1}^{k}\frac{\left ( n_i - np_{i0} \right )^{2}}{np_{i0}}
$$

bajo la hipótesis nula, resultando que asintóticamente tiene la misma distribución que $-2\ln\lambda(n_1,\dotsc,n_k )$. Una justificación de este hecho radica en observar que

$$
-2\ln\lambda(n_1,\dotsc,n_k )=-2\sum_{i=1}^{k}n_i \ln\left( \frac {p_{i0}}{\widehat{p}_i} \right)
$$

y si se emplea que, aproximadamente, $\ln(x)≃(x-1)-\frac{1}{2} (x-1)^2$, se tiene que

$$
\begin{equation}
\begin{split}
-2\ln\lambda(n_1,\dotsc,n_k ) & \simeq -2\sum_{i=1}^{k}n_i \left[ \left( \frac{p_{i0}}{\widehat{p}_i}- 1 \right) - \frac{1}{2} \left( \frac{p_{i0}}{\widehat{p}_i} -1 \right)^{2} \right] \\ 
 & \simeq \sum_{i=1}^{k}n_i \left( \frac{p_{i0}}{\widehat{p}_i} -1 \right)^{2} \\
 & \simeq \sum_{i=1}^{k} \frac{\left( n_{i} - np_{i0} \right)^2}{n_{i}} \\
 & \simeq \sum_{i=1}^{k} \frac{\left( n_{i} -np_{i0} \right)^2}{np_{i0}},
\end{split}
\end{equation}
$$

donde la última aproximación se debe a que $n_i\simeq np_{i0}$. Por lo que de manera resumida

$$
\begin{equation}
D^2 (p_0,\widehat{p}_i )=\sum_{i=1}^{k} \frac{\left( n_{i} -np_{i0} \right)^2}{np_{i0}} \xrightarrow{cs }\chi_{k-1}^{2}.
(\#eq:distancia-cuadrada)
\end{equation}
$$

Como se ha mostrado, la distribución del estadístico dado en la ecuación \@ref(eq:distancia-cuadrada), bajo la hipótesis nula $\left(p_i=p_{i0} \right)$, tiende hacia la distribución ji-cuadrado con $k-1$ grados de libertad cuando $n$ es grande. Lo grande que debe ser $n$, para que la aproximación sea aceptablemente buena, está en relación con los valores de las probabilidades $p_i$; usualmente se considera que $np_i≥5 \ \textit{para cada} \;i=1,2,\dotsc,k$.

Ello sirve, a menudo, para delimitar los conjuntos $I_i$, que han de elegirse de forma que se cumplan las restricciones $np_i≥5$.

Sin embargo, puesto que el contraste no discrimina entre distribuciones que asignen la misma probabilidad a los conjuntos $I_i$, es aconsejable que el número $k$ de particiones no sea inferior a 5 (salvo en ajustes a distribuciones discretas o cualitativas con menor número de valores posibles). Así, tendrá que ser alguna de las $p_{i0}≤ \frac{1}{5}$ y, por consiguiente, es necesario que sea $n≥25$. Aunque, evidentemente, se conseguirá mayor exactitud cuanto más grande sea $n$.

Se observa, que las $n_i$ son las frecuencias observadas de los intervalos $I_i$ en la muestra, mientras que $np_{i0}$ son las frecuencias esperadas de los mismos bajo la hipótesis nula, por lo que el estadístico \@ref(eq:distancia-cuadrada) es comúnmente referido como

$$
\begin{equation}
\chi^{2}=\sum_{i=1}^{k} \frac{\left( O_{i} -E_{i} \right)^2}{E_{i}} \overset{cs}{\rightarrow}\chi_{k-1}^{2}.
(\#eq:ba-jicuadrado)
\end{equation}
$$

En base la estadístico de prueba $\chi^{2}$ dado en la ecuación \@ref(eq:ba-jicuadrdada), la hipótesis alternativa, en este caso, puede ser rechazada si

$$
\begin{equation}
\chi^{2}\geq \chi_{k-1;1-\alpha}^{2}.
(\#eq:criterio-ba-jicuadrado)
\end{equation}
$$

Usando el $p{valor}$ la hipótesis alternativa es rechazada si la siguiente proposición es verdadera

$$
\begin{equation}
p_{valor \ aprox}=1-F_{\chi_{k-1}^{2}}\left(\chi^{2} \right) \leq \alpha.
(\#eq:pus-ba-jicuadrado)
\end{equation}
$$

Donde $F_{\chi_{k-1}^{2}}\left(\chi^{2} \right)$ es la función de distribución acumula de una variable aleatoria ji-cuadrado con $k-1$ grados de libertad, la cual se encuentra ampliamente tabulada. La distribución base de <span style='color: blue;'>R</span> proporciona las siguientes funciones, las cuales permiten evaluar estas y otras funciones relacionadas con esta distribución de probabilidad:

-   `dchisq(x, df, ncp = 0, log = FALSE)`
-   `pchisq(q, df, ncp = 0, lower.tail = TRUE, log.p = FALSE)`
-   `qchisq(p, df, ncp = 0, lower.tail = TRUE, log.p = FALSE)`
-   `rchisq(n, df, ncp = 0)`.

La función `dchisq` calcula la función de densidad ji-cuadrado, `pchisq` evalúa la función de distribución ji-cuadrado, `qchisq` determina los cuantiles de la distribución ji-cuadrado y `rchisq` genera números aleatorios de esta distribución. Los parámetros de estas funciones se describen en la tabla \@ref(tab:par-dist-jicuadrado):

(ref:foo6) Descripción de los parámetros de funciones de <span style='color: blue;'>R</span> relacionadas con la distribución ji-cuadrado


```{.r .watch-out}
knitr::kable(
  data.frame(
    stringsAsFactors = FALSE,
    Parámetros = c(
      "x, q", "p", "n", "df",
      "ncp", "log, log.p", "lower.tail"
    ),
    Descripción = c(
      "Vector de cuantiles.",
      "Vector de Probabilidades.",
      "Número de observaciones. Si length(n) > 1, se considera que la longitud es el número requerido.", "Grados de libertad (mayor que 0).",
      "Parámetro de no centralidad (mayor que cero).",
      "Lógico; si es TRUE, las probabilidades p se dan como log(p)",
      "Lógico; si es TRUE (por defecto), las probabilidades son $P[X \\leq x]$, de lo contrario, $P[X > x]$."
    )
  ),
  booktabs = TRUE,
  caption = "(ref:foo6)",
  escape = FALSE
) %>%
  kable_styling(
    bootstrap_options = "striped",
    full_width = FALSE,
    fixed_thead = T
  ) %>%
  kable_classic_2()
```

<table class="table table-striped lightable-classic-2" style='width: auto !important; margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
<caption>(\#tab:par-dist-jicuadrado)(ref:foo6)</caption>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> Parámetros </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> Descripción </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> x, q </td>
   <td style="text-align:left;"> Vector de cuantiles. </td>
  </tr>
  <tr>
   <td style="text-align:left;"> p </td>
   <td style="text-align:left;"> Vector de Probabilidades. </td>
  </tr>
  <tr>
   <td style="text-align:left;"> n </td>
   <td style="text-align:left;"> Número de observaciones. Si length(n) &gt; 1, se considera que la longitud es el número requerido. </td>
  </tr>
  <tr>
   <td style="text-align:left;"> df </td>
   <td style="text-align:left;"> Grados de libertad (mayor que 0). </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ncp </td>
   <td style="text-align:left;"> Parámetro de no centralidad (mayor que cero). </td>
  </tr>
  <tr>
   <td style="text-align:left;"> log, log.p </td>
   <td style="text-align:left;"> Lógico; si es TRUE, las probabilidades p se dan como log(p) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> lower.tail </td>
   <td style="text-align:left;"> Lógico; si es TRUE (por defecto), las probabilidades son $P[X \leq x]$, de lo contrario, $P[X > x]$. </td>
  </tr>
</tbody>
</table>
<br/>

Por otro lado la función `chisq.test(x, y = NULL, correct = TRUE, p = rep(1/length(x), length(x)), rescale.p = FALSE, simulate.p.value = FALSE, B = 2000)` contenida en la distribución base de <span style='color: blue;'>R</span> permite ejecutar la prueba de bondad de ajuste ji-cuadrado. Los parámetros de esta función se describen en la tabla \@ref(tab:par-prueba-jicuadrado).

(ref:foo7) Descripción de los parámetros de la función `chisq.test` de <span style='color: blue;'>R</span>


```{.r .watch-out}
knitr::kable(
  data.frame(
    stringsAsFactors = FALSE,
    Parámetros = c(
      "x", "y", "correct", "p",
      "rescale.p", "simulate.p.value", "B"
    ),
    Descripción = c(
      "Un vector o matriz numérica. x e y también pueden ser factores.",
      "Un vector numérico; ignorado si x es una matriz. Si x es un factor, y debe ser un factor de la misma longitud.",
      "Lógica que indica si se debe aplicar o no la corrección de continuidad de Yate al calcular el estadístico de prueba para las tablas de 2 por 2. No se realiza ninguna corrección si simulate.p.value. = TRUE.",
      "Un vector de probabilidades de la misma longitud de x. Se da un error si alguna entrada de p es negativa.",
      "Un parámetro lógico; si es TRUE entonces p es reescalado (si es necesario) para sumar a 1. Si rescale.p es FALSE, y p no suma a 1, se da un error.",
      "Un indicador lógico que indica si se deben calcular los valores p mediante la simulación de Monte Carlo.",
      "Un número entero que especifique el número de réplicas utilizadas en el ensayo de Monte Carlo."
    )
  ),
  booktabs = TRUE,
  caption = "\\label{tab2:par-prueba-jicuadrado}Descripción de los parámetros de la función `chisq.test` de R",
  escape = FALSE
) %>%
  kable_styling(
    bootstrap_options = "striped",
    full_width = FALSE,
    fixed_thead = T
  ) %>%
  kable_classic_2()
```

<table class="table table-striped lightable-classic-2" style='width: auto !important; margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
<caption>(\#tab:par-prueba-jicuadrado)\label{tab2:par-prueba-jicuadrado}Descripción de los parámetros de la función `chisq.test` de R</caption>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> Parámetros </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> Descripción </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> x </td>
   <td style="text-align:left;"> Un vector o matriz numérica. x e y también pueden ser factores. </td>
  </tr>
  <tr>
   <td style="text-align:left;"> y </td>
   <td style="text-align:left;"> Un vector numérico; ignorado si x es una matriz. Si x es un factor, y debe ser un factor de la misma longitud. </td>
  </tr>
  <tr>
   <td style="text-align:left;"> correct </td>
   <td style="text-align:left;"> Lógica que indica si se debe aplicar o no la corrección de continuidad de Yate al calcular el estadístico de prueba para las tablas de 2 por 2. No se realiza ninguna corrección si simulate.p.value. = TRUE. </td>
  </tr>
  <tr>
   <td style="text-align:left;"> p </td>
   <td style="text-align:left;"> Un vector de probabilidades de la misma longitud de x. Se da un error si alguna entrada de p es negativa. </td>
  </tr>
  <tr>
   <td style="text-align:left;"> rescale.p </td>
   <td style="text-align:left;"> Un parámetro lógico; si es TRUE entonces p es reescalado (si es necesario) para sumar a 1. Si rescale.p es FALSE, y p no suma a 1, se da un error. </td>
  </tr>
  <tr>
   <td style="text-align:left;"> simulate.p.value </td>
   <td style="text-align:left;"> Un indicador lógico que indica si se deben calcular los valores p mediante la simulación de Monte Carlo. </td>
  </tr>
  <tr>
   <td style="text-align:left;"> B </td>
   <td style="text-align:left;"> Un número entero que especifique el número de réplicas utilizadas en el ensayo de Monte Carlo. </td>
  </tr>
</tbody>
</table>
<br/>

Una forma más fácil de evaluar la cantidad dada por la ecuación \@ref(eq:ba-jicuadrado2), es

$$
\begin{equation}
\chi ^{2}=\sum_{i=1}^{k}\frac{O_{i}^{2}}{E_i}-n.
(\#eq:ba-jicuadrado2)
\end{equation}
$$

No obstante, es recomendable hacer la determinación a partir del cuadrado de cada diferencia, para detectar cuál es la causante del rechazo, en caso de producirse éste.

Como se dijo al principio de esta sección, se aborda ahora el problema de ajuste a una distribución parcialmente especificada, en la práctica una situación que se presenta con mayor frecuencia. Se empleará la notación $p_i (\theta_1,\dotsc,\theta_r )$ para las probabilidades de los intervalos $I_i$ con el fin de resaltar esta diferencia. En uniformidad con el caso anterior, todo se reduce a contrastar, a partir de los datos $n_i$, con $i=1,\dotsc,k$, la hipótesis nula $H_0:$ provienen de una multinomial de parámetros $n$, $p_i (\theta_1,\dotsc,\theta_r )$, para $i=1,\dotsc,k$, con $k≥r$, frente a la hipótesis alternativa $H_1:$ provienen de una multinomial de parámetros $n$, $p_i (\theta_1,\dotsc,\theta_r )$, para $i=1,\dotsc,k$.

Si se emplea el contraste de la $RV$ se debe utilizar

$$
\lambda\left ( n_{1}, \dotsc, n_{k} \right ) =\frac{\underset{\theta_1, \dotsc, \theta_k}{SUP}\frac{n!}{n_1! \dotsm n_k!} p_1^{n_1}\left ( \theta _1, \dotsc,\theta_r \right ) \dotsm p_k^{n_k}\left ( \theta _1, \dotsc,\theta_r \right )}{\underset{p_1, \dotsc, p_k}{SUP}\frac{n!}{n_1! \dotsm n_k!}\left ( p_1 \right )^{n_1} \dotsm \left ( p_k \right )^{n_k}}.
$$ 

Para el cálculo del denominador, se sabe que el supremo se alcanza para $\widehat{p}_i=\frac{n_i}{n}$, con $i=1,\dotsc,k$ y para el numerador, hay que resolver en $θ_1,\dotsc,θ_r$ el sistema

$$
\left.\begin{matrix}
 \sum_{i=1}^{k}\frac{n_i}{p_i\left ( \theta _1, \dotsc, \theta _r \right )}\frac{\partial }{\partial \theta _j}p_i\left ( \theta _1, \dotsc, \theta _r \right )=0\\
j=1, \dotsc, r
\end{matrix}\right\}
$$

En el caso de que exista regularidad suficiente, las soluciones de este sistema $p(\widehat{\theta}_i )$ maximizarán el numerador de la $RV$, con lo que la región crítica ha de ser

$$
RC= \left\{\prod_{i=1}^{k}\left ( \frac{p_i\left ( \widehat{\theta } \right )}{n_i/n} \right )^{n_i} \leq k \right\}
$$

y por los resultados asintóticos de la $RV$ , bajo $H_0$, se sigue que

$$
-2\ln\lambda \left ( n_1, \dotsc, n_k \right )\xrightarrow{cs }\chi _{k-r-1}^{2}
$$

ya que la hipótesis nula tiene de dimensión $r$, mientras que $H_0∪H_1$ tiene de dimensión $k-1$.

Por lo tanto, la región crítica viene dada por

$$
RC=\left\{\lambda \left ( n_1, \dotsc, n_k \right )=\prod_{i=1}^{k}\left ( \frac{p_i\left ( \widehat{\theta } \right )}{n_i/n} \right )^{n_i}\leq k \right\}
$$

Alternativamente, se puede aplicar el método de la distancia de K. Pearson para lo que se introduce la cantidad

$$
D^{2}\left ( p\left ( \widehat{\theta } \right ),\widehat{p} \right )=\sum_{i=1}^{k}\lambda _i\left ( \frac{n_i}{n} -p_i\left ( \widehat{\theta } \right ) \right )^{2}
$$

y si se pone $\lambda_i=\frac{n}{p_i\left ( \widehat{\theta } \right )}$ queda

$$
\begin{equation}
D^{2}\left ( p\left ( \widehat{\theta } \right ),\widehat{p} \right )=\sum_{i=1}^{k}\frac{\left ( n_i-np_i\left ( \widehat{\theta } \right ) \right )^{2}}{np_i\left ( \widehat{\theta } \right )}\xrightarrow{cs }\chi _{k-r-1}^{2}.
(\#eq:ba-jicuadrado2)
\end{equation}
$$

Dado que los $n_i$ son las frecuencias observadas de los intervalos $I_i$ en la muestra, mientras que $np_i \left( \widehat{\theta } \right)$ son las frecuencias esperadas estimadas de los mismos bajo la hipótesis nula, es costumbre escribir la ecuación \@ref(eq:ba-jicuadrado2) como

$$
\begin{equation}
\chi^{2} =\sum_{i=1}^{k}\frac{\left ( O_i-\widehat{E}_i \right )^{2}}{\widehat{E}_i}\xrightarrow{cs }\chi _{k-r-1}^{2}.
(\#eq:ba-jicuadrado-pe)
\end{equation}
$$

Para estimar las frecuencias esperadas de cada clase, es necesario estimar las probabilidades de ocurrencia de cada clase. Para ello es necesario estimar los parámetros de la distribución a la cual se quiere ajustar los datos, a partir de una muestra. La función `fitdistr(x, densfun, start, ...)` del paquete `MASS` permite estimar los parámetros de algunas distribuciones univariadas. Los parámetros de la función se describen en la tabla \@ref(tab:par-fitdistr).

(ref:foo8) Descripción de los parámetros de la función `fitdistr` de <span style='color: blue;'>R</span>


```{.r .watch-out}
knitr::kable(
  data.frame(
    stringsAsFactors = FALSE,
    Parámetros = c("x", "densfun", "start", "..."),
    Descripción = c(
      "Un vector numérico de longitud mayor o igual a uno que contiene los valores de la muestra.",
      "Se reconocen las distribuciones \"beta\", \"cauchy\", \"chi-squared\", \"exponential\", \"gamma\", \"geometric\", \"lognormal\", \"logistic\", \"negative binomial\", \"normal\", \"Poisson\", \"t\" and \"weibull\", ignorándose otros casos.",
      "Una lista con nombre con los parámetros a optimizar con valores iniciales. Esto puede omitirse para algunas de las distribuciones mencionadas y debe omitirse para otras (véase Detalles).",
      "Parámetros adicionales, tanto para densfun como para optimizar. En particular, se puede utilizar para especificar límites a través de la parte inferior, superior o ambas. Si se incluyen argumentos de densfun (o la función de densidad especificada por la cadena de caracteres correspondientes) se mantendrán fijos."
    )
  ),
  booktabs = TRUE,
  caption = "(ref:foo8)",
  escape = FALSE
) %>%
  kable_styling(
    bootstrap_options = "striped",
    full_width = FALSE,
    fixed_thead = T
  ) %>%
  kable_classic_2()
```

<table class="table table-striped lightable-classic-2" style='width: auto !important; margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
<caption>(\#tab:par-fitdistr)(ref:foo8)</caption>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> Parámetros </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> Descripción </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> x </td>
   <td style="text-align:left;"> Un vector numérico de longitud mayor o igual a uno que contiene los valores de la muestra. </td>
  </tr>
  <tr>
   <td style="text-align:left;"> densfun </td>
   <td style="text-align:left;"> Se reconocen las distribuciones "beta", "cauchy", "chi-squared", "exponential", "gamma", "geometric", "lognormal", "logistic", "negative binomial", "normal", "Poisson", "t" and "weibull", ignorándose otros casos. </td>
  </tr>
  <tr>
   <td style="text-align:left;"> start </td>
   <td style="text-align:left;"> Una lista con nombre con los parámetros a optimizar con valores iniciales. Esto puede omitirse para algunas de las distribuciones mencionadas y debe omitirse para otras (véase Detalles). </td>
  </tr>
  <tr>
   <td style="text-align:left;"> ... </td>
   <td style="text-align:left;"> Parámetros adicionales, tanto para densfun como para optimizar. En particular, se puede utilizar para especificar límites a través de la parte inferior, superior o ambas. Si se incluyen argumentos de densfun (o la función de densidad especificada por la cadena de caracteres correspondientes) se mantendrán fijos. </td>
  </tr>
</tbody>
</table>
<br/>

### Implementación en <span style='color: blue;'>R</span> de la Prueba de Bondad de Ajuste Ji-cuadrado {#jicuadrado1-R}

**Ejemplo 3:** En 1865 Mendel descubrió un código genético básico mediante la cría de guisantes verdes y amarillos en un experimento. Debido a que el gen amarillo del guisante es dominante, los híbridos de la primera generación fueron amarillos, pero los de la segunda generación eran aproximadamente 75% amarillos y 25% verdes. El color verde reaparece en la segunda generación porque hay un 25% de probabilidad de que dos guisantes, ambos con un gen amarillo y otros con un gen verde, contribuyan con el verde a la siguiente semilla híbrida. En otro experimento de guisantes se consideró tanto el color como las características de la textura. Los resultados de los experimentos se muestran en la tabla \@ref(tab:datos-mendel).


```{.r .watch-out}
datos3 <- data.frame(
  stringsAsFactors = FALSE,
  Tipo.de.Guisante = c(
    "Amarillo Liso", "Amarillo Arrugado",
    "Verde Liso", "Verde Arrugado"
  ),
  Frecuencia.Observada = c(315L, 101L, 108L, 32L),
  Frecuencia.Esperada = c(313L, 104L, 104L, 35L)
)
knitr::kable(
  datos3,
  booktabs = TRUE,
  col.names = c("Tipo de Guisante", "Frecuencia Observada", "Frecuencia Esperada"),
  caption = "\\label{tab2:datos-mendel}Distribución de los guisantes",
  escape = FALSE
) %>%
  kable_styling(
    bootstrap_options = "striped",
    full_width = FALSE,
    fixed_thead = T
  ) %>%
  kable_classic_2()
```

<table class="table table-striped lightable-classic-2" style='width: auto !important; margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
<caption>(\#tab:datos-mendel)\label{tab2:datos-mendel}Distribución de los guisantes</caption>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> Tipo de Guisante </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> Frecuencia Observada </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> Frecuencia Esperada </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Amarillo Liso </td>
   <td style="text-align:right;"> 315 </td>
   <td style="text-align:right;"> 313 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Amarillo Arrugado </td>
   <td style="text-align:right;"> 101 </td>
   <td style="text-align:right;"> 104 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Verde Liso </td>
   <td style="text-align:right;"> 108 </td>
   <td style="text-align:right;"> 104 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Verde Arrugado </td>
   <td style="text-align:right;"> 32 </td>
   <td style="text-align:right;"> 35 </td>
  </tr>
</tbody>
</table>
<br/>

Pruebe la hipótesis de que la ocurrencia de las dos características está determinado por el modelo propuesto (número esperado), con un tamaño $\alpha=0,01$. Los datos fueron tomados de Kvan y Vidakovic (2007, pág. 157).

En este ejemplo la hipótesis nula que se quiere contrastar es que las frecuencia observados en la muestra se ajustan a las frecuencias esperadas propuestas por Mendel. Ahora, como la distribución de frecuencias propuesta en la hipótesis nula está completamente definida, el estadístico de prueba viene dado por la ecuación \@ref(eq:ba-jicuadrado). Luego, evaluando las frecuencias observadas y esperadas en esta ecuación se obtiene el siguiente valor:

$$
\chi^{2}=\sum_{i=1}^{4} \frac{\left( O_{i} -E_{i} \right)^2}{E_{i}} = \frac{\left( 315 -313 \right)^2}{313}+\frac{\left( 101 -104 \right)^2}{104}+\frac{\left( 108 - 104 \right)^2}{104}+\frac{\left( 32 - 35 \right)^2}{35}= 0.510307.
$$ 

Según la ecuación \@ref(eq:criterio-ba-jicuadrado), el valor del estadístico tabulado es $\chi_{k-1=3;1-\alpha=0,99}^{2} = 11,3449$ . Mientras que de la ecuación \@ref(eq:pus-ba-jicuadrado), el $p_{valor \, aprox}=1-F_{\chi_{k-1=3}^{2}}\left( 0,5103\right)=1-0,0834 = 0,9166$. Dado que el estadístico de prueba $\left(0,5103\right)$ es mucho menor que el estadístico tabulado $\left(13,2767 \right)$ no se puede rechazar la hipótesis de que las frecuencias observadas se ajustan al modelo propuesto por Mendel. A la misma conclusión se llega si se usa el $p_{valor}$ como criterio de decisión. Los resultados antes descritos se pueden obtener con el siguiente script.


```{.r .watch-out}
alfa <- 0.01
Ji_cuadrado <- sum((datos3$Frecuencia.Observada - datos3$Frecuencia.Esperada)^2 /
  datos3$Frecuencia.Esperada)
est_tab <- qchisq(p = 1 - alfa, df = nrow(datos3) - 1)
p_valor <- 1 - pchisq(q = Ji_cuadrado, df = nrow(datos3) - 1)
paste("El estadísitico Ji-cuadrado =", round(Ji_cuadrado, digits = 4))
paste("El estadístico tabulado =", round(est_tab, digits = 4))
paste("El p_valor =", round(p_valor, digits = 4))
```

```{.bg-warning}
#> [1] "El estadísitico Ji-cuadrado = 0.5103"
#> [1] "El estadístico tabulado = 11.3449"
#> [1] "El p_valor = 0.9166"
```
<br/>

El estadístico de prueba $\chi^2$ y el $p_{valor \, aprox.}$ se pueden obtener de manera directa con la función `chisq.test` descrita en la tabla \@ref(tab:par-prueba-jicuadrado), como se muestra en el siguiente código.


```{.r .watch-out}
chisq.test(
  x = datos3$Frecuencia.Observada,
  p = datos3$Frecuencia.Esperada /
    sum(datos3$Frecuencia.Esperada)
)
```

```{.bg-warning}
#> 
#> 	Chi-squared test for given probabilities
#> 
#> data:  datos3$Frecuencia.Observada
#> X-squared = 0.51031, df = 3, p-value = 0.9166
```
<br/>

**Ejemplo 4:** Se ha estimado que el número de accidentes diarios en cada regimiento del ejército sigue una distribución de Poisson de parámetro 2. Un determinado regimiento ha recogido, durante 200 días, los siguientes datos:

$$
\begin{array}{lccccccc}
\hline
N^{\circ} \, de \, accidentes & 0  &  1  &  2 &  3  &  4  &  5 & 6 & 7 \\
N^{\circ} \, de \, días       & 22 &  53 & 58 &  39 &  20 &  5 & 2 & 1 \\
\hline
\end{array}
$$

Los datos fueron tomados de Vélez y García (2012, pág. 435).

En la tabla \@ref(tab:datos4) se aprecian las frecuencia observadas y esperadas. Donde las frecuencias esperadas viene dada por $E_i=np_{0i}$. Donde $n$ es el tamaño de la muestra (200) y $p_{0i}$ son las probabilidades esperadas, las cuales se obtiene sustituyendo en la función de probabilidad de Poisson

$$
f\left(x, \lambda \right)=e^{\lambda}\frac{\lambda^x}{x!},
$$

$x=0, 1, 2, \dotsc7$ y $\lambda=2$. La distribución base de <span style='color: blue;'>R</span> tiene la función `dpois` que permite evaluar esta función.


```{.r .watch-out}
datos4 <- tibble(
  accidentes = c(0L, 1L, 2L, 3L, 4L, 5L, 6L, 7L),
  dias = c(22L, 53L, 58L, 39L, 20L, 5L, 2L, 1L)
) %>%
  mutate(
    p0i = dpois(x = accidentes, lambda = 2),
    Ei = sum(dias) * p0i
  )
knitr::kable(
  datos4,
  digits = 4,
  booktabs = TRUE,
  row.names = TRUE,
  col.names = c("$N^{\\circ} \\, de \\, accidentes$", "$N^{\\circ} \\, de \\, días \\left( O_i \\right)$", "$p_{0i}$", "$E_i$"),
  format.args = list(decimal.mark = ",", big.mark = "."),
  caption = "\\label{tab2:ejemplo4}Frecuencias obsevadas y esperadas",
  escape = FALSE
) %>%
  kable_styling(
    bootstrap_options = "striped",
    full_width = FALSE,
    fixed_thead = T
  ) %>%
  row_spec(which(datos4$Ei < 5), color = "red", strikeout = T) %>%
  kable_classic_2()
```

<table class="table table-striped lightable-classic-2" style='width: auto !important; margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
<caption>(\#tab:datos4)\label{tab2:ejemplo4}Frecuencias obsevadas y esperadas</caption>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;">   </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> $N^{\circ} \, de \, accidentes$ </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> $N^{\circ} \, de \, días \left( O_i \right)$ </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> $p_{0i}$ </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> $E_i$ </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 22 </td>
   <td style="text-align:right;"> 0,1353 </td>
   <td style="text-align:right;"> 27,0671 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 53 </td>
   <td style="text-align:right;"> 0,2707 </td>
   <td style="text-align:right;"> 54,1341 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 58 </td>
   <td style="text-align:right;"> 0,2707 </td>
   <td style="text-align:right;"> 54,1341 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 39 </td>
   <td style="text-align:right;"> 0,1804 </td>
   <td style="text-align:right;"> 36,0894 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 20 </td>
   <td style="text-align:right;"> 0,0902 </td>
   <td style="text-align:right;"> 18,0447 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 0,0361 </td>
   <td style="text-align:right;"> 7,2179 </td>
  </tr>
  <tr>
   <td style="text-align:left;text-decoration: line-through;color: red !important;"> 7 </td>
   <td style="text-align:right;text-decoration: line-through;color: red !important;"> 6 </td>
   <td style="text-align:right;text-decoration: line-through;color: red !important;"> 2 </td>
   <td style="text-align:right;text-decoration: line-through;color: red !important;"> 0,0120 </td>
   <td style="text-align:right;text-decoration: line-through;color: red !important;"> 2,4060 </td>
  </tr>
  <tr>
   <td style="text-align:left;text-decoration: line-through;color: red !important;"> 8 </td>
   <td style="text-align:right;text-decoration: line-through;color: red !important;"> 7 </td>
   <td style="text-align:right;text-decoration: line-through;color: red !important;"> 1 </td>
   <td style="text-align:right;text-decoration: line-through;color: red !important;"> 0,0034 </td>
   <td style="text-align:right;text-decoration: line-through;color: red !important;"> 0,6874 </td>
  </tr>
</tbody>
</table>
<br/>

Como se nota en la tabla generada por el script anterior, las clases 7 y 8 tienen frecuencias esperadas menores que 5, y peor aún, la de la clase 8 es menor que 1. Por tanto, estas se funden con la clase 6 para dar lugar a la clase 5 o más accidentes en un día, para que sea procedente utilizar la prueba de bondad de ajuste Ji-Cuadrado.


```{.r .watch-out}
datos4 <- bind_rows(datos4[1:5, ], colSums(datos4[6:8, ])) %>%
  mutate(accidentes = as.character(accidentes))
datos4[6, 1] <- "$\\geq5$"
knitr::kable(
  datos4,
  digits = 4,
  booktabs = TRUE,
  row.names = TRUE,
  col.names = c("$N^{\\circ} \\, de \\, accidentes$", "$N^{\\circ} \\, de \\, días \\left( O_i \\right)$", "$p_{0i}$", "$E_i$"),
  align = c("r"),
  format.args = list(decimal.mark = ",", big.mark = "."),
  caption = NULL,
  escape = FALSE
) %>%
  kable_styling(
    bootstrap_options = "striped",
    full_width = FALSE,
    fixed_thead = T
  ) %>%
  kable_classic_2()
```

<table class="table table-striped lightable-classic-2" style='width: auto !important; margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;">   </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> $N^{\circ} \, de \, accidentes$ </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> $N^{\circ} \, de \, días \left( O_i \right)$ </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> $p_{0i}$ </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> $E_i$ </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:right;"> 0 </td>
   <td style="text-align:right;"> 22 </td>
   <td style="text-align:right;"> 0,1353 </td>
   <td style="text-align:right;"> 27,0671 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 53 </td>
   <td style="text-align:right;"> 0,2707 </td>
   <td style="text-align:right;"> 54,1341 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 58 </td>
   <td style="text-align:right;"> 0,2707 </td>
   <td style="text-align:right;"> 54,1341 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 39 </td>
   <td style="text-align:right;"> 0,1804 </td>
   <td style="text-align:right;"> 36,0894 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 20 </td>
   <td style="text-align:right;"> 0,0902 </td>
   <td style="text-align:right;"> 18,0447 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:right;"> $\geq5$ </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 0,0516 </td>
   <td style="text-align:right;"> 10,3113 </td>
  </tr>
</tbody>
</table>
<br/>

Dado que con este ajuste se ha logrado que todas las frecuencias esperadas sean mayor que 5 y como la distribución que se pretende ajustar a los datos está completamente especificada. Entonces el estadístico calculado, según la ecuación \@ref(eq:ba-jicuadrado), viene dado por:

$$
\chi^{2}=\sum_{i=1}^{4} \frac{\left( O_{i} -E_{i} \right)^2}{E_{i}} = \frac{\left( 22 - 27,06 \right)^2}{27,06}+\frac{\left(53 -54,14 \right)^2}{54,14}+\frac{\left(58 - 54,14 \right)^2}{54,14}+\frac{\left(39 - 36,08 \right)^2}{36,08}+\frac{\left(20 - 18,04 \right)^2}{18,04}+\frac{\left(8 - 10,30 \right)^2}{10,30}= 2.2130844.
$$

De manera análoga al ejemplo 3, de la ecuación \@ref(eq:pus-ba-jicuadrado), el $p_{valor \, aprox}$ es:

$$
p_{valor \, aprox}=1-F_{\chi_{k-1=5}^{2}}\left( 2,2131 \right)=1- 0,1811 = 0,8189.
$$

De los resultados anteriores, se concluye que no se puede rechazar la hipótesis de que los accidentes diarios en cada regimiento del ejercito sigue una distribución de Poisson con $\lambda = 2$, a un nivel de significancia del 5%.


```{.r .watch-out}
chisq.test(
  x = datos4$dias, p = datos4$Ei,
  rescale.p = TRUE
)
```

```{.bg-warning}
#> 
#> 	Chi-squared test for given probabilities
#> 
#> data:  datos4$dias
#> X-squared = 2.2104, df = 5, p-value = 0.8193
```
<br/>

**Ejemplo 5:** Una máquina, en correcto estado de funcionamiento, produce piezas cuya longitud se distribuye normalmente con media 10,5 y desviación estándar 0,15. En determinado momento se observa la siguiente muestra, de tamaño 40, de la longitud de las piezas producidas:

$$
\begin{array}{ccccccc}
\hline
10,39 & 10,66 & 10,12 & 10,32 & 10,25 & 10,91 & 10,52 & 10,83\\
10,72 & 10,28 & 10,35 & 10,46 & 10,54 & 10,72 & 10,23 & 10,18\\
10,62 & 10,49 & 10,32 & 10,61 & 10,64 & 10,23 & 10,29 & 10,78\\
10,81 & 10,39 & 10,34 & 10,62 & 10,75 & 10,34 & 10,41 & 10,81\\
10,64 & 10,53 & 10,31 & 10,46 & 10,47 & 10,43 & 10,57 & 10,74\\
\hline
\end{array}
$$ 

y se desea saber si la muestra avala que la máquina está funcionando correctamente. Los datos fueron tomados de Vélez y García (2012, pág. 437).

Para aplicar el contraste de bondad de ajuste ji-cuadrado, hay que construir la tabla de distribución de frecuencia en intervalos de clases; como $n=40$, se pueden hacer 8 intervalos, con números esperado de observaciones igual a 5, buscando los cuantiles de órdenes $0,125, 0,25, 0,375, \dotsc, 0,875$. El siguiente código permite ejecutar el procedimiento descrito previamente.


```{.r .watch-out}
lp <- c(
  10.39, 10.66, 10.12, 10.32, 10.25, 10.91, 10.52, 10.83,
  10.72, 10.28, 10.35, 10.46, 10.54, 10.72, 10.23, 10.18,
  10.62, 10.49, 10.32, 10.61, 10.64, 10.23, 10.29, 10.78,
  10.81, 10.39, 10.34, 10.62, 10.75, 10.34, 10.41, 10.81,
  10.64, 10.53, 10.31, 10.46, 10.47, 10.43, 10.57, 10.74
)
datos5 <- as.data.frame(table(cut(
  x = lp, breaks =
    qnorm(
      p = seq(
        from = 0, to = 1,
        by = 0.125
      ),
      mean = 10.5, sd = 0.15
    )
)))
datos5 <- datos5 %>%
  transmute(
    Clase = str_replace_all(
      string = as.character(Var1),
      c(
        "\\(" = "$\\\\left(",
        "," = ";\\\\:",
        "\\." = ",",
        "Inf" = "\\\\infty",
        "\\]" = "\\\\right]$"
      )
    ),
    Oi = Freq,
    p0i = rep(x = 1 / 8, times = 8),
    Ei = p0i * sum(Oi)
  )
knitr::kable(
  datos5,
  booktabs = TRUE,
  row.names = TRUE,
  col.names = c("Clase", "$O_i$", "$p_{0i}$", "$E_i$"),
  align = c("r"),
  format.args = list(decimal.mark = ",", big.mark = "."),
  caption = NULL,
  escape = FALSE
) %>%
  kable_styling(
    bootstrap_options = "striped",
    full_width = FALSE,
    fixed_thead = T
  ) %>%
  kable_classic_2()
```

<table class="table table-striped lightable-classic-2" style='width: auto !important; margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;">   </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> Clase </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> $O_i$ </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> $p_{0i}$ </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> $E_i$ </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:right;"> $\left(-\infty;\:10,33\right]$ </td>
   <td style="text-align:right;"> 10 </td>
   <td style="text-align:right;"> 0,125 </td>
   <td style="text-align:right;"> 5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:right;"> $\left(10,33;\:10,4\right]$ </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 0,125 </td>
   <td style="text-align:right;"> 5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:right;"> $\left(10,4;\:10,45\right]$ </td>
   <td style="text-align:right;"> 2 </td>
   <td style="text-align:right;"> 0,125 </td>
   <td style="text-align:right;"> 5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:right;"> $\left(10,45;\:10,5\right]$ </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 0,125 </td>
   <td style="text-align:right;"> 5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:right;"> $\left(10,5;\:10,55\right]$ </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 0,125 </td>
   <td style="text-align:right;"> 5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:right;"> $\left(10,55;\:10,6\right]$ </td>
   <td style="text-align:right;"> 1 </td>
   <td style="text-align:right;"> 0,125 </td>
   <td style="text-align:right;"> 5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:right;"> $\left(10,6;\:10,67\right]$ </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 0,125 </td>
   <td style="text-align:right;"> 5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:right;"> $\left(10,67;\: \infty\right]$ </td>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:right;"> 0,125 </td>
   <td style="text-align:right;"> 5 </td>
  </tr>
</tbody>
</table>
<br/>

El siguiente código muestra la ejecución de la prueba de bondad de ajuste Ji-cuadrado para contrastar la hipótesis de que la longitud de la pieza se distribuye normalmente con media 10,5 y desviación estándar 0,15. Note que no se ha especificado el valor del parámetro `p` de la función `chisq.test`, por lo tanto este asume el valor por defecto descrito en la tabla \@ref(tab:par-prueba-jicuadrado).

Como se observa en la salida, el $p_{valor\, aprox} = 0.0445075$ lo que indica que se rechaza la hipótesis de que la longitud de la pieza se ajusta a una distribución normal con media 10,5 y desviación estándar 0,15; con un nivel de confianza del 95%.


```{.r .watch-out}
chisq.test(x = datos5$Oi)
```

```{.bg-warning}
#> 
#> 	Chi-squared test for given probabilities
#> 
#> data:  datos5$Oi
#> X-squared = 14.4, df = 7, p-value = 0.04451
```
<br/>

La siguiente gráfica corrobora la conclusión de que los datos no se ajustan a una distribución $N\left(\mu = 10,5;\: \sigma = 0,15 \right)$. Como se ve en la figura \@ref(fig:densidad-lp) la densidad $N\left(\mu = 10,5; \sigma = 0,15 \right)$ , representada por la línea roja, no se ajusta a la densidad empírica de los datos muestrales, representada por la línea azul.


```{.r .watch-out}
ggplot(as.data.frame(lp), aes(x = lp)) +
  geom_histogram(aes(y = ..density..),
    bins = 8, color = "white", fill = "steelblue"
  ) +
  stat_function(
    fun = dnorm, color = "red",
    args = list(mean = 10.5, sd = 0.15)
  ) +
  geom_line(stat = "density", color = "blue") +
  expand_limits(y = 0) +
  xlab("Longitud de la pieza") +
  ylab("Densidad") +
  theme_minimal()
```

<div class="figure">
<img src="_main_files/figure-html/densidad-lp-1.png" alt="Densidad de la longitud de la pieza" width="672" />
<p class="caption">(\#fig:densidad-lp)Densidad de la longitud de la pieza</p>
</div>







**Ejemplo 6:** La muestra del *ejemplo 5* ha puesto de relieve un funcionamiento incorrecto de la máquina, que no se ajusta a la distribución $N\left(\mu = 10,5; \: \sigma = 0,15 \right)$. Cabe, sin embargo, la posibilidad de que el desajuste haya afectado a la media y la desviación típica, pero que la distribución de la longitud de las piezas producidas siga siendo de tipo normal. Para verificar tal posibilidad hay que estimar (por máxima verosimilitud) la media y la desviación típica poblacional.

El estimación por máxima verosimilitud de la media de la distribución normal es:

$$
\hat{\mu} = \bar{x} = \frac{\sum_{i=1}^{n}xi}{n} = \frac{420,08}{40} = 10,502.
$$

Mientras que la estimación de la desviación estándar por este método viene dada por:

$$
\hat{\sigma }=\sqrt{\frac{\sum_{i=1}^{n}\left ( x_i - \bar{x} \right )^{2}}{n}}=\sqrt{\frac{1,64144}{40}}= 0,2025734.
$$

La función `fitdistr` del paquete `MASS` cuyos parámetro se describen en la tabla \@ref(tab:par-fitdistr) calcula los estimadores de máxima verosimilitud de algunas distribuciones de probabilidad univariadas, entre ellas la distribución normal. Con el siguiente código se determinan tales estimaciones, a partir de la información de la muestra.


```{.r .watch-out}
fitdistr(x = lp, densfun = "normal")
```

```{.bg-warning}
#>       mean           sd     
#>   10.50200000    0.20257344 
#>  ( 0.03202967) ( 0.02264840)
```
<br/>

El siguiente código permite construir la tabla de distribución de frecuencia observadas y esperadas estimadas. Estas últimas se calculan a partir de las probabilidades estimadas de cada clase ($\hat{E}_i=n\hat{p}_{0i}$). La construcción de la tabla se obtiene con el siguiente código.


```{.r .watch-out}
lim_int <- c(-Inf, 10.2, 10.3, 10.4, 10.5, 10.6, 10.7, 
             10.8, 10.9, Inf)
datos6 <- as.data.frame(table(cut(
  x = lp, breaks = lim_int
)))
datos6 <- datos6 %>%
  transmute(
    Clase = str_replace_all(
      string = as.character(Var1),
      c(
        "\\(" = "$\\\\left(",
        "," = ";\\\\:",
        "\\." = ",",
        "Inf" = "\\\\infty",
        "\\]" = "\\\\right]$"
      )
    ),
    Oi = Freq,
    p0i = diff(pnorm(q = lim_int, mean = 10.502, sd = 0.2026)),
    Ei = p0i * sum(Oi)
  )
knitr::kable(
  datos6,
  digits = 4,
  booktabs = TRUE,
  row.names = TRUE,
  col.names = c("Clase", "$O_i$", "$\\hat{p}_{0i}$", "$\\hat{E}_i$"),
  align = c("r"),
  format.args = list(decimal.mark = ",", big.mark = "."),
  caption = NULL,
  escape = FALSE
) %>%
  kable_styling(
    bootstrap_options = "striped",
    full_width = FALSE,
    fixed_thead = T
  ) %>%
  row_spec(which(datos6$Ei < 5), color = "red", strikeout = T) %>%
  kable_classic_2()
```

<table class="table table-striped lightable-classic-2" style='width: auto !important; margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;">   </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> Clase </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> $O_i$ </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> $\hat{p}_{0i}$ </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> $\hat{E}_i$ </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;text-decoration: line-through;color: red !important;"> 1 </td>
   <td style="text-align:right;text-decoration: line-through;color: red !important;"> $\left(-\infty;\:10,2\right]$ </td>
   <td style="text-align:right;text-decoration: line-through;color: red !important;"> 2 </td>
   <td style="text-align:right;text-decoration: line-through;color: red !important;"> 0,0680 </td>
   <td style="text-align:right;text-decoration: line-through;color: red !important;"> 2,7212 </td>
  </tr>
  <tr>
   <td style="text-align:left;text-decoration: line-through;color: red !important;"> 2 </td>
   <td style="text-align:right;text-decoration: line-through;color: red !important;"> $\left(10,2;\:10,3\right]$ </td>
   <td style="text-align:right;text-decoration: line-through;color: red !important;"> 5 </td>
   <td style="text-align:right;text-decoration: line-through;color: red !important;"> 0,0913 </td>
   <td style="text-align:right;text-decoration: line-through;color: red !important;"> 3,6537 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:right;"> $\left(10,3;\:10,4\right]$ </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 0,1479 </td>
   <td style="text-align:right;"> 5,9180 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:right;"> $\left(10,4;\:10,5\right]$ </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 0,1887 </td>
   <td style="text-align:right;"> 7,5496 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:right;"> $\left(10,5;\:10,6\right]$ </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 0,1896 </td>
   <td style="text-align:right;"> 7,5857 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:right;"> $\left(10,6;\:10,7\right]$ </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 0,1501 </td>
   <td style="text-align:right;"> 6,0033 </td>
  </tr>
  <tr>
   <td style="text-align:left;text-decoration: line-through;color: red !important;"> 7 </td>
   <td style="text-align:right;text-decoration: line-through;color: red !important;"> $\left(10,7;\:10,8\right]$ </td>
   <td style="text-align:right;text-decoration: line-through;color: red !important;"> 5 </td>
   <td style="text-align:right;text-decoration: line-through;color: red !important;"> 0,0935 </td>
   <td style="text-align:right;text-decoration: line-through;color: red !important;"> 3,7420 </td>
  </tr>
  <tr>
   <td style="text-align:left;text-decoration: line-through;color: red !important;"> 8 </td>
   <td style="text-align:right;text-decoration: line-through;color: red !important;"> $\left(10,8;\:10,9\right]$ </td>
   <td style="text-align:right;text-decoration: line-through;color: red !important;"> 3 </td>
   <td style="text-align:right;text-decoration: line-through;color: red !important;"> 0,0459 </td>
   <td style="text-align:right;text-decoration: line-through;color: red !important;"> 1,8369 </td>
  </tr>
  <tr>
   <td style="text-align:left;text-decoration: line-through;color: red !important;"> 9 </td>
   <td style="text-align:right;text-decoration: line-through;color: red !important;"> $\left(10,9;\: \infty\right]$ </td>
   <td style="text-align:right;text-decoration: line-through;color: red !important;"> 1 </td>
   <td style="text-align:right;text-decoration: line-through;color: red !important;"> 0,0247 </td>
   <td style="text-align:right;text-decoration: line-through;color: red !important;"> 0,9895 </td>
  </tr>
</tbody>
</table>
<br/>

Como se puede ver en la tabla anterior, las dos primeras clases tienen frecuencias esperadas estimadas menores que 5, por la que estas se funden en una sola para dar lugar a la clase longitud de la pieza menor o igual a 10,3. Del mismo modo, las tres últimas clases tienen frecuencias esperadas estimadas menores que 5 por lo se colapsan para dar lugar a la clase longitud de la pieza mayor que 10,7. La nueva tabla se muestra con el siguiente código.


```{.r .watch-out}
lim_int <- c(-Inf, 10.3, 10.4, 10.5, 10.6, 10.7, Inf)
datos6 <- as.data.frame(table(cut(
  x = lp, breaks = lim_int
)))
datos6 <- datos6 %>%
  transmute(
    Clase = str_replace_all(
      string = as.character(Var1),
      c(
        "\\(" = "$\\\\left(",
        "," = ";\\\\:",
        "\\." = ",",
        "Inf" = "\\\\infty",
        "\\]" = "\\\\right]$"
      )
    ),
    Oi = Freq,
    p0i = diff(pnorm(q = lim_int, mean = 10.502, sd = 0.2026)),
    Ei = p0i * sum(Oi)
  )
knitr::kable(
  datos6,
  digits = 4,
  booktabs = TRUE,
  row.names = TRUE,
  col.names = c("Clase", "$O_i$", "$\\hat{p}_{0i}$", "$\\hat{E}_i$"),
  align = c("r"),
  format.args = list(decimal.mark = ",", big.mark = "."),
  caption = NULL,
  escape = FALSE
) %>%
  kable_styling(
    bootstrap_options = "striped",
    full_width = FALSE,
    fixed_thead = T
  ) %>%
  kable_classic_2()
```

<table class="table table-striped lightable-classic-2" style='width: auto !important; margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;">   </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> Clase </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> $O_i$ </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> $\hat{p}_{0i}$ </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> $\hat{E}_i$ </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:right;"> $\left(-\infty;\:10,3\right]$ </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 0,1594 </td>
   <td style="text-align:right;"> 6,3749 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:right;"> $\left(10,3;\:10,4\right]$ </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 0,1479 </td>
   <td style="text-align:right;"> 5,9180 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:right;"> $\left(10,4;\:10,5\right]$ </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 0,1887 </td>
   <td style="text-align:right;"> 7,5496 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:right;"> $\left(10,5;\:10,6\right]$ </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 0,1896 </td>
   <td style="text-align:right;"> 7,5857 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:right;"> $\left(10,6;\:10,7\right]$ </td>
   <td style="text-align:right;"> 6 </td>
   <td style="text-align:right;"> 0,1501 </td>
   <td style="text-align:right;"> 6,0033 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:right;"> $\left(10,7;\: \infty\right]$ </td>
   <td style="text-align:right;"> 9 </td>
   <td style="text-align:right;"> 0,1642 </td>
   <td style="text-align:right;"> 6,5685 </td>
  </tr>
</tbody>
</table>
<br/>

Fíjese que la prueba de hipótesis que se plantea en este ejemplo es compuesta, dado que los parámetros de la distribución bajo la hipótesis nula son desconocidos (la media $\mu$ y la desviación estándar $\sigma$). Por lo tanto, el estadístico de la prueba se distribuye asintóticamente Ji-cuadrado con $k-r-1=6-2-1=3$ grados de libertad. El valor del estadístico $\chi^{2}$ y el $p_{valor \,aprox}$ se generan con el siguiente código.


```{.r .watch-out}
X2 <- sum((datos6$Oi - datos6$Ei)^2 / datos6$Ei)
p.valor <- pchisq(q = X2, df = nrow(datos6) - 2 - 1, lower.tail = F)
paste("El estadístic Ji-Cuadrado =", X2)
paste("el p.valor =", p.valor)
```

```{.bg-warning}
#> [1] "El estadístic Ji-Cuadrado = 3.70690303455726"
#> [1] "el p.valor = 0.294902155121217"
```
<br/>

Dado que el $p_{valor \, aprox} = 0,2949022$ es mayor que 0,05 no se puede rechazar la hipótesis de que los datos proviene de una población normal.

Si se propone ahora realizar la prueba, de tal manera que la tabla de frecuencia no amerite ser corregida, como se realizó en el *ejemplo 5*. La tabla quedaría de la siguiente manera, ejecutando el siguiente script.


```{.r .watch-out}
datos6 <- as.data.frame(table(cut(
  x = lp, breaks =
    qnorm(
      p = seq(
        from = 0, to = 1,
        by = 0.125
      ),
      mean = 10.502, sd = 0.2026
    )
)))
datos6 <- datos6 %>%
  transmute(
    Clase = str_replace_all(
      string = as.character(Var1),
      c(
        "\\(" = "$\\\\left(",
        "," = ";\\\\:",
        "\\." = ",",
        "Inf" = "\\\\infty",
        "\\]" = "\\\\right]$"
      )
    ),
    Oi = Freq,
    p0i = rep(x = 1 / 8, times = 8),
    Ei = p0i * sum(Oi)
  )
knitr::kable(
  datos6,
  booktabs = TRUE,
  row.names = TRUE,
  col.names = c("Clase", "$O_i$", "$p_{0i}$", "$E_i$"),
  align = c("r"),
  format.args = list(decimal.mark = ",", big.mark = "."),
  caption = NULL,
  escape = FALSE
) %>%
  kable_styling(
    bootstrap_options = "striped",
    full_width = FALSE,
    fixed_thead = T
  ) %>%
  kable_classic_2()
```

<table class="table table-striped lightable-classic-2" style='width: auto !important; margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;">   </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> Clase </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> $O_i$ </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> $p_{0i}$ </th>
   <th style="text-align:right;position: sticky; top:0; background-color: #FFFFFF;"> $E_i$ </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 1 </td>
   <td style="text-align:right;"> $\left(-\infty;\:10,27\right]$ </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 0,125 </td>
   <td style="text-align:right;"> 5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2 </td>
   <td style="text-align:right;"> $\left(10,27;\:10,37\right]$ </td>
   <td style="text-align:right;"> 8 </td>
   <td style="text-align:right;"> 0,125 </td>
   <td style="text-align:right;"> 5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 3 </td>
   <td style="text-align:right;"> $\left(10,37;\:10,44\right]$ </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 0,125 </td>
   <td style="text-align:right;"> 5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 4 </td>
   <td style="text-align:right;"> $\left(10,44;\:10,5\right]$ </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 0,125 </td>
   <td style="text-align:right;"> 5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 5 </td>
   <td style="text-align:right;"> $\left(10,5;\:10,57\right]$ </td>
   <td style="text-align:right;"> 3 </td>
   <td style="text-align:right;"> 0,125 </td>
   <td style="text-align:right;"> 5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 6 </td>
   <td style="text-align:right;"> $\left(10,57;\:10,64\right]$ </td>
   <td style="text-align:right;"> 4 </td>
   <td style="text-align:right;"> 0,125 </td>
   <td style="text-align:right;"> 5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 7 </td>
   <td style="text-align:right;"> $\left(10,64;\:10,74\right]$ </td>
   <td style="text-align:right;"> 5 </td>
   <td style="text-align:right;"> 0,125 </td>
   <td style="text-align:right;"> 5 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 8 </td>
   <td style="text-align:right;"> $\left(10,74;\: \infty\right]$ </td>
   <td style="text-align:right;"> 7 </td>
   <td style="text-align:right;"> 0,125 </td>
   <td style="text-align:right;"> 5 </td>
  </tr>
</tbody>
</table>
<br/>

Como se puede ver en la tabla anterior, todas las frecuencias esperadas son mayores o iguales que 5, por lo que se procede a aplicar la prueba, por medio de las siguientes instrucciones.


```{.r .watch-out}
X2 <- sum((datos6$Oi - datos6$Ei)^2 / datos6$Ei)
p.valor <- pchisq(q = X2, df = nrow(datos6) - 2 - 1, lower.tail = F)
paste("El estadístic Ji-Cuadrado =", X2)
paste("el p.valor =", p.valor)
```

```{.bg-warning}
#> [1] "El estadístic Ji-Cuadrado = 4"
#> [1] "el p.valor = 0.54941595135278"
```
<br/>

Como se nota en la salida anterior el $p_{valor \, aprox} = 0,549416$ lo que conduce, de igual manera, a aceptar la hipótesis de que los datos se distribuyen normalmente.

### Problemas Propuestos {#problemas-jicuadrado1}

1)	Juan Pérez, vendedor de la empresa La Margariteña, S.A, tiene siete empresas que visita semanalmente. Se piensa que las ventas del señor Juan pueden describirse mediante la distribución binomial, con probabilidad de venta de 0,45. Examinando la distribución de frecuencia observada del número de ventas por semana del señor Juan, determine si la distribución corresponde en efecto a la distribución sugerida. Use el nivel de significancia de 5\%.

$$
\begin{array}{lcccccccc}
\hline
Número\,de\,ventas\,por\,semana &	0	& 1 &	2	& 3 &	4 &	5 &	6 &	7\\
Frecuencia\,del\,número\,de\,ventas &	25 & &	32 &	61 &	47 &	39 &	21 &	18 &	12\\
\hline
\end{array}
$$

2)	Los vigilantes que monitorean una entrada de seguridad a una empresa están teniendo problemas con las largas filas que se forman durante las horas de tráfico pico. Antes de continuar su análisis del problema, necesitan saber la distribución aproximada de la llegada de carros. Recabaron los siguientes datos cada minuto entre las 7:10 y las 8:00.

$$
\begin{array}{lccccccccccc}
\hline
Número\, de\, llegadas  &	1 &	2 &	3 &	4 &	5 &	6 &	7 &	8 &	9 &	10 &	11\\
Frecuencia  &	5 &	3 &	2 &	6 &	6 &	2 &	6 &	10 &	4 &	4 &	2\\
\hline
\end{array}
$$

Pruebe si una distribución de Poisson con una media de seis describe adecuadamente estos datos, use el nivel de significancia de 5%.

3)	Los impactos de 60 bombas volantes lanzadas por los alemanes, en la segunda guerra mundial, sobre la superficie de Londres, considerada cuadrada, fueron clasificados en 9 zonas obtenidas dividiendo cada lado en tres partes iguales, con los siguientes resultados:

$$
\begin{array}{ccc}
\hline
8 & 7 & 3\\
5 & 9 & 11\\
6 & 4 & 7\\
\hline
\end{array}
$$

Los responsables de la defensa querían averiguar si las bombas tenían algún objetivo concreto o se distribuían al azar sobre la superficie de la ciudad. Los datos fueron tomados de Vélez y García (2012, pág. 438).


## Prueba de Bondad de Ajuste Kolgomorov-Smirnov {#kolgomorov1}

La prueba de bondad de ajuste Kolgomorov-Smirnov  se usa para contrastar la hipótesis de que una variable continua tiene cierta distribución de probabilidad. Como se mostró en la sección \@ref(jicuadrado1), la prueba Ji-cuadrado discretiza las observaciones muestrales en conjuntos de una cierta partición, para comparar después el histograma de frecuencias observadas con el histograma de frecuencias que debería obtenerse de acuerdo con la hipótesis a contrastar. De esta manera, en el caso de distribuciones poblacionales continuas, dicho test no hace el mejor uso posible de la información contenida en la muestra, puesto que ignora el valor exacto de las observaciones. Con un tamaño muestral relativamente grande, que permita utilizar una partición fina del conjunto de observaciones, el efecto puede no ser acusado. Pero con un número pequeño de observaciones y, por tanto, con una partición grosera de ellas, la pérdida de información puede ser importante; además, en tal caso, la distribución exacta del estadístico de contraste puede estar alejada de la distribución $\chi^{2}$ límite.

Así pues, en el contraste de bondad de ajuste de una distribución teórica unidimensional de tipo continuo, es a menudo preferible el uso de la prueba Kolgomorov-Smirnov.

### Racionalización de la Prueba de Bondad de Ajuste Kolgomorov-Smirnov {#racionalizacion-kolgomorov1}

Sea $x_1,\dotsc,x_n$ una realización particular de una m.a.s. de tamaño $n$ de una población $X$ con función de distribución $F\left(x \right)$ continua, la función de distribución empírica o muestral se define mediante

$$
\begin{equation}
F_{n}^{*}\left ( x \right )=\begin{cases}
0, & \text{ si } x< x_{\left ( i \right )}\\
\frac{i}{n}, & \text{ si } x_{\left ( i \right )}\leq x< x_{\left ( i +1\right )}, \text{ para }\: i=1, \dotsc, n-1 \\
1, & \text{ si } x\geq x_{\left ( n \right )}.
\end{cases}
(\#eq:fdae)
\end{equation}
$$

Donde $x_{\left ( 1 \right )},\dotsc,x_{\left ( n \right )}$ es la muestra ordenada de menor a mayor, con $i= 0,1,\dotsc,n$; donde aquí se añade por convenio $x_{\left ( 0 \right )}=-\infty$ y $x_{\left ( n+1 \right )}=-\infty$. Alternativamente la función $F_{n}^{*}\left ( x \right )$ puede escribirse como:

$$
\begin{equation}
F_{n}^{*}\left ( x \right )=\frac{1}{n}\sum_{i=1}^{n}I_{(-\infty , x]}\left ( x_{i} \right )
(\#eq:fdae2)
\end{equation}
$$

La función `ecdf` determina la función de distribución acumulada empírica de una muestra dada por la ecuación \@ref(eq:fdae), mientras que la función `Ecdf` del paquete `Hmisc` la calcula y la grafica.

::: {.definition #estks name="Estadísticos de Kolmogorov-Smirnov"}
Se llaman _estadísticos unilaterales de Kolmogorov-Smirnov_ a

$$
\begin{equation} 
\begin{split} 
D_{n}^{+} & = \underset{x}{Sup}\left ( F_{n}^{*}\left ( x \right )-F\left ( x \right ) \right )\\
D_{n}^{-} & = \underset{x}{Sup}\left ( F\left ( x \right ) - F_{n}^{*} (x)\right )
\end{split}
(\#eq:estuks)
\end{equation}
$$

y _estadístico bilateral de Kolmogorov-Smirnov_ a

$$
\begin{equation}
D_{n}=\underset{x}{Sup}\left| F_{n}^{*}\left ( x \right ) -F\left ( x \right )\right|
(\#eq:estbks)
\end{equation}
$$
:::

Para demostrar que los _estadísticos de Kolmogorov-Smirnov_ son de distribución libre se hace uso del siguiente teorema.

::: {.theorem #Glivenko-Cantelli name="Glivenko-Cantelli"}
Si se tiene  una m.a.s. de tamaño $n$ de una población $X$, con función de distribución $F\left ( x \right )$
, para cualquier número real positivo arbitrario $\varepsilon$, se tiene
que

$$
\begin{equation}
\displaystyle \lim_{n \to \infty}P\left\{ \underset{x\in \mathbb{R}}{Sup}\left| F_{n}^{*}\left ( x \right )-F\left ( x \right )\right|\geq \varepsilon  \right\}=0.
(\#eq:Glivenko-Cantelli)
\end{equation}
$$
:::

El teorema de Glivenko-Cantelli (teorema \@ref(thm:Glivenko-Cantelli)), asegura que $F_{n}^{*}\left ( x \right )$ converge a $F\left ( x \right )$ uniformemente con probabilidad uno. Por lo tanto la magnitud de las diferencias entre $F_{n}^{*}\left ( x \right )$ y $F\left ( x \right )$, proporciona información de la compatibilidad entre la muestra y $F\left ( x \right )$.

::: {.proposition #dist-lib}
Para una m.a.s. de tamaño $n$ de una población $X$ con función de distribución $F\left ( x \right )$ continua, la función de distribución de los estadísticos $D_{n}^{+}$, $D_{n}^{-}$ y $D_{n}$ no
depende de $F$.
:::

::: {.proof #dem-kolgomorov}
Recordando que $x_{\left ( 0 \right )}=-\infty$ y $x_{\left ( n+1 \right )}=-\infty$, se puede poner

$$
D_{n}^{+}=\underset{0\leq i\leq n}{m\acute{a}x}\:\:\underset{x_{\left ( i \right )}\leq x\leq x_{\left ( i+1 \right )}}{Sup}\left ( \frac{i}{n} -F\left ( x \right )\right )
$$

Como en el intervalo $\left [ x_{\left ( n \right )},\: x_{\left ( n+1 \right )}\right )$ la función $1-F\left ( x \right )$ es positiva o nula y $\underset{x_{\left ( i \right )}\leq x< x_{\left ( i+1 \right )}}{Sup}\left ( \frac{i}{n} -F\left ( x_{\left ( i \right )} \right )\right )=\frac{i}{n}-F\left ( x_{\left ( i \right )} \right )$ se tiene que

$$
\begin{equation}
D_{n}^{+}=\underset{1\leq i\leq n}{m\acute{a}x}\left ( \frac{i}{n} -F\left ( x_{\left ( i \right )} \right )\right )
(\#eq:Dmas)
\end{equation}
$$

como $F\left ( x_{\left ( i \right )} \right )=U_{\left ( i \right )}$
es el estadístico ordenado de orden $i$ de una muestra
de la v.a. $U\left ( a=0, b=1 \right )$; es claro que esta expresión no depende de la distribución $F$.

Análogamente

$$
\begin{split}
D_{n}^{-}&=\underset{0\leq i\leq n}{m\acute{a}x} \:\:\underset{x_{\left ( i \right )}\leq x\leq x_{\left ( i+1 \right )}}{Sup}\left ( F\left ( x \right ) -\frac{i}{n}\right )\\
&=\underset{0\leq i\leq n}{m\acute{a}x}\left ( F\left ( x_{\left ( i+1 \right )} \right )-\frac{i}{n} \right )\\
&=\underset{1\leq i\leq n}{m\acute{a}x}\left ( F\left ( x_{\left ( i \right )} \right )-\frac{i-1}{n} \right )\\
\end{split}
$$

sin más que observar que en el intervalo $\left[x_{\left ( 0 \right )},x_{\left ( 1 \right )}\right)$  la diferencia $F\left ( x_{\left ( i+1 \right )} \right )-\frac{i}{n}$ es positiva o nula.

En Resumen,

$$
\begin{equation}
D_{n}^{-}=\underset{1\leq i\leq n}{m\acute{a}x}\left ( F\left ( x_{\left ( i \right )} \right )-\frac{i-1}{n} \right ).
(\#eq:Dmenos)
\end{equation}
$$

Por último al ser 

$$
\begin{equation}
D_{n}=m\acute{a}x\left\{D_{n}^{+}, D_{n}^{-}\right\}
(\#eq:D)
\end{equation}
$$

se sigue que la distribución de los tres estadísticos es independiente de la función de distribución $F$.

Se puede entonces enunciar esta proposición diciendo, que los estadísticos de Kolmogorov-Smirnov tienen distribución libre.
:::

Las distribuciones asintóticas de estos estadísticos fueron obtenidas por
Kolmogorov (1933, 1941) y por Smirnov (1939, 1948), quien dió una demostración más sencilla y generalizó el problema al caso de dos muestras.

La distribución de probabilidad de los estadísticos de Kolgomorov-Smirnov se encuentra ampliamente tabulada para diferentes valores de $n$ y $\alpha$. En particular, las funciones `pkolm` y `pkolmin` del paquete `kolmim` permite evaluar la distribución de Kolgomorov.

La utilización de estos estadísticos, para contrastar si una m.a.s. proviene de una distribución totalmente especificada $F_0\left(x\right)$, queda recogida en la tabla \@ref(tab:regioncritica-kolgomorovsmirnov).


```{.r .watch-out}
knitr::kable(
  data.frame(
    stringsAsFactors = FALSE,
    H0 = c("", "$F\\left(x \\right)=F_0\\left(x \\right)$", ""),
    H1 = c(
      "$F\\left(x \\right)\\neq F_0\\left(x \\right)$",
      "$F\\left(x \\right)>F_0\\left(x \\right)$",
      "$F\\left(x \\right)<F_0\\left(x \\right)$"
    ),
    region_critica = c(
      "$D_{n}> d_{n,\\alpha }$",
      "$D_{n}^{+}> d_{n,\\alpha}^{+}$",
      "$D_{n}^{-}> d_{n,\\alpha }^{-}$"
    ),
    p_valor = c(
      "$P \\left( D_{n} > d_{n} \\right)$",
      "$P \\left(D_{n}^{+ }> d_{n}^{+} \\right)$",
      "$P \\left(D_{n}^{-}> d_{n}^{-} \\right)$"
    )
  ),
  booktabs = TRUE,
  row.names = FALSE,
  col.names = c("$H_0$", "$H_1$", "Región Crítica", "$p_{valor}$"),
  align = c("c", "c", "c"),
  caption = "\\label{tab2:regioncritica-kolgomorovsmirnov}Regiones críticas del test de Kolmogorov-Smirnov para una muestra",
  escape = FALSE
) %>%
  kable_styling(
    bootstrap_options = "striped",
    full_width = FALSE,
    fixed_thead = T
  ) %>%
  kable_classic_2()
```

<table class="table table-striped lightable-classic-2" style='width: auto !important; margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
<caption>(\#tab:regioncritica-kolgomorovsmirnov)\label{tab2:regioncritica-kolgomorovsmirnov}Regiones críticas del test de Kolmogorov-Smirnov para una muestra</caption>
 <thead>
  <tr>
   <th style="text-align:center;position: sticky; top:0; background-color: #FFFFFF;"> $H_0$ </th>
   <th style="text-align:center;position: sticky; top:0; background-color: #FFFFFF;"> $H_1$ </th>
   <th style="text-align:center;position: sticky; top:0; background-color: #FFFFFF;"> Región Crítica </th>
   <th style="text-align:center;position: sticky; top:0; background-color: #FFFFFF;"> $p_{valor}$ </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> $F\left(x \right)\neq F_0\left(x \right)$ </td>
   <td style="text-align:center;"> $D_{n}> d_{n,\alpha }$ </td>
   <td style="text-align:center;"> $P \left( D_{n} > d_{n} \right)$ </td>
  </tr>
  <tr>
   <td style="text-align:center;"> $F\left(x \right)=F_0\left(x \right)$ </td>
   <td style="text-align:center;"> $F\left(x \right)>F_0\left(x \right)$ </td>
   <td style="text-align:center;"> $D_{n}^{+}> d_{n,\alpha}^{+}$ </td>
   <td style="text-align:center;"> $P \left(D_{n}^{+ }> d_{n}^{+} \right)$ </td>
  </tr>
  <tr>
   <td style="text-align:center;">  </td>
   <td style="text-align:center;"> $F\left(x \right)<F_0\left(x \right)$ </td>
   <td style="text-align:center;"> $D_{n}^{-}> d_{n,\alpha }^{-}$ </td>
   <td style="text-align:center;"> $P \left(D_{n}^{-}> d_{n}^{-} \right)$ </td>
  </tr>
</tbody>
</table>
<br/>

La función `ks.test(x, y, …, alternative = c("two.sided", "less", "greater"), exact = NULL)` de la distribución base de <span style='color: blue;'>R</span> realiza la _prueba de bondad de ajuste Kolmogorov-Smirnov_ de una o dos muestras. Los parámetros de esta función se describen en la tabla \@ref(tab:par-kstest).

(ref:foo9) Descripción de los parámetros de la función `ks.test` de <span style='color: blue;'>R</span>


```{.r .watch-out}
knitr::kable(
  data.frame(
    stringsAsFactors = FALSE,
    Parámetros = c("x", "y", "…", "alternative"),
    Descripción = c(
      "Un vector numérico de datos.",
      "Un vector numérico de datos o una cadena de caracteres que designa una función de distribución acumulada o una función de distribución acumulada conocida como por ejemplo pnorm. Sólo son válidas las FDA continuas",
      "Parámetros de la distribución especificada en y (como una cadena de caracteres)",
      "Indica la hipótesis alternativa y debe ser: \" \"two.sided\" (por defecto), \" less \" o \" greater \". Puede especificar sólo la letra inicial del valor, pero el nombre del argumento debe estar completo"
    )
  ),
  booktabs = TRUE,
  caption = "(ref:foo9)",
  escape = FALSE
) %>%
  kable_styling(
    bootstrap_options = "striped",
    full_width = FALSE,
    fixed_thead = T
  ) %>%
  kable_classic_2()
```

<table class="table table-striped lightable-classic-2" style='width: auto !important; margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
<caption>(\#tab:par-kstest)(ref:foo9)</caption>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> Parámetros </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> Descripción </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> x </td>
   <td style="text-align:left;"> Un vector numérico de datos. </td>
  </tr>
  <tr>
   <td style="text-align:left;"> y </td>
   <td style="text-align:left;"> Un vector numérico de datos o una cadena de caracteres que designa una función de distribución acumulada o una función de distribución acumulada conocida como por ejemplo pnorm. Sólo son válidas las FDA continuas </td>
  </tr>
  <tr>
   <td style="text-align:left;"> … </td>
   <td style="text-align:left;"> Parámetros de la distribución especificada en y (como una cadena de caracteres) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> alternative </td>
   <td style="text-align:left;"> Indica la hipótesis alternativa y debe ser: " "two.sided" (por defecto), " less " o " greater ". Puede especificar sólo la letra inicial del valor, pero el nombre del argumento debe estar completo </td>
  </tr>
</tbody>
</table>
<br/>

De igual manera, la función `ks.test.imp(x, y, ...)` del paquete `kolmin` permite ejecutar esta prueba. 

### Implementación en <span style='color: blue;'>R</span> de la Prueba de Bondad de Ajuste Kolmogorov-Smirnov {#kolgomorov1-R} 

**Ejemplo 7:** Consideremos un experimento industrial en el que tenemos una muestra de n=10 tejidos sometido a un lavado. El objetivo del experimento es analizar el desempeño de un nuevo detergente experimental para la ropa. Específicamente, la variable de respuesta bajo estudio es la llamada reflectancia, es decir, la proporción de luz incidente que una determinada superficie (de tela) es capaz de reflejar, lo que puede ser considerado una medida relacionada con la eficacia de limpieza del detergente. Supongamos que deseamos probar, en el nivel de significación $\alpha=5\%$, si la reflectancia está o no uniformemente distribuida, es decir, si sigue la ley de distribución U(0,1). Los datos fueron tomados de Bonnini et al (2014, pág. 28).

$$
\begin{array}{ccccccc}
\hline
\mathbf{Pieza \, de\,  Tela} &	1 &	2 &	3 &	4 &	5\\
\mathbf{Reflectancia} &	0,608 &	0,533 &	0,912 &	0,498 &	0,885\\
\mathbf{Pieza\, de\,  Tela} &	6 &	7 &	8 &	9 &	10\\
\mathbf{Reflectancia} &	0,291 &	0,805 &	0,436 &	0,868 &	0,712\\
\hline
\end{array}
$$

Para aplicar la prueba de bondad de ajuste Kolmogorov-Smirnov se debe construir la tabla con la distribución de frecuencias observadas y esperadas, y a partir de estas se obtienen los estadísticos de Kolmogorov-Smirnov $D_{n}^{+}$, $D_{n}^{-}$ y $D_n$, definidos en las ecuaciones \@ref(eq:Dmas), \@ref(eq:Dmenos) y \@ref(eq:D), respectivamente.


```{.r .watch-out}
reflectancia <- c(
  0.608, 0.533, 0.912, 0.498, 0.885, 0.291, 0.805,
  0.436, 0.868, 0.712
)
Xi <- sort(unique(reflectancia))
i <- numeric(length(Xi))
for (j in 1:length(Xi)) {
  i[j] <- sum(reflectancia <= Xi[j])
}
datos7 <- data.frame(
  i = i,
  Xi = Xi
) %>%
  mutate(
    Fn = i / length(reflectancia),
    F0 = punif(q = Xi),
    D_mas = Fn - F0,
    D_menos = F0 - (i - 1) / length(reflectancia)
  )
kableExtra::kbl(
  datos7,
  digits = 3,
  booktabs = TRUE,
  row.names = NA,
  col.names = c(
    "$i$",
    "$x_{\\left( i \\right)}$",
    "$F_{n}^{*}\\left( x_{\\left( i \\right)} \\right)$",
    "$F_{0}\\left( x_{\\left( i \\right)} \\right)$",
    "$D_{n}^{+}$",
    "$D_{n}^{-}$"
  ),
  align = c("c", "c", "c", "c", "c", "c"),
  format.args = list(decimal.mark = ",", big.mark = "."),
  caption = "\\label{tab2:datos7}Distribución empírica de la reflectancia Vs la distribución $U\\left(a=0, b =1 \\right)$",
  escape = FALSE
) %>%
  kable_styling(
    bootstrap_options = "striped",
    full_width = FALSE,
    fixed_thead = T
  ) %>%
  column_spec(
    5,
    color = if_else(datos7$D_mas == max(datos7$D_mas), "red", "black"),
    bold = if_else(datos7$D_mas == max(datos7$D_mas), TRUE, FALSE)
  ) %>%
  column_spec(
    6,
    color = if_else(datos7$D_menos == max(datos7$D_menos), "red", "black"),
    bold = if_else(datos7$D_menos == max(datos7$D_menos), TRUE, FALSE)
  ) %>%
  kable_classic_2()
```

<table class="table table-striped lightable-classic-2" style='width: auto !important; margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
<caption>(\#tab:datos7)\label{tab2:datos7}Distribución empírica de la reflectancia Vs la distribución $U\left(a=0, b =1 \right)$</caption>
 <thead>
  <tr>
   <th style="text-align:center;position: sticky; top:0; background-color: #FFFFFF;"> $i$ </th>
   <th style="text-align:center;position: sticky; top:0; background-color: #FFFFFF;"> $x_{\left( i \right)}$ </th>
   <th style="text-align:center;position: sticky; top:0; background-color: #FFFFFF;"> $F_{n}^{*}\left( x_{\left( i \right)} \right)$ </th>
   <th style="text-align:center;position: sticky; top:0; background-color: #FFFFFF;"> $F_{0}\left( x_{\left( i \right)} \right)$ </th>
   <th style="text-align:center;position: sticky; top:0; background-color: #FFFFFF;"> $D_{n}^{+}$ </th>
   <th style="text-align:center;position: sticky; top:0; background-color: #FFFFFF;"> $D_{n}^{-}$ </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 0,291 </td>
   <td style="text-align:center;"> 0,1 </td>
   <td style="text-align:center;"> 0,291 </td>
   <td style="text-align:center;color: black !important;"> -0,191 </td>
   <td style="text-align:center;color: black !important;"> 0,291 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 0,436 </td>
   <td style="text-align:center;"> 0,2 </td>
   <td style="text-align:center;"> 0,436 </td>
   <td style="text-align:center;color: black !important;"> -0,236 </td>
   <td style="text-align:center;font-weight: bold;color: red !important;"> 0,336 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:center;"> 0,498 </td>
   <td style="text-align:center;"> 0,3 </td>
   <td style="text-align:center;"> 0,498 </td>
   <td style="text-align:center;color: black !important;"> -0,198 </td>
   <td style="text-align:center;color: black !important;"> 0,298 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4 </td>
   <td style="text-align:center;"> 0,533 </td>
   <td style="text-align:center;"> 0,4 </td>
   <td style="text-align:center;"> 0,533 </td>
   <td style="text-align:center;color: black !important;"> -0,133 </td>
   <td style="text-align:center;color: black !important;"> 0,233 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 5 </td>
   <td style="text-align:center;"> 0,608 </td>
   <td style="text-align:center;"> 0,5 </td>
   <td style="text-align:center;"> 0,608 </td>
   <td style="text-align:center;color: black !important;"> -0,108 </td>
   <td style="text-align:center;color: black !important;"> 0,208 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 6 </td>
   <td style="text-align:center;"> 0,712 </td>
   <td style="text-align:center;"> 0,6 </td>
   <td style="text-align:center;"> 0,712 </td>
   <td style="text-align:center;color: black !important;"> -0,112 </td>
   <td style="text-align:center;color: black !important;"> 0,212 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 7 </td>
   <td style="text-align:center;"> 0,805 </td>
   <td style="text-align:center;"> 0,7 </td>
   <td style="text-align:center;"> 0,805 </td>
   <td style="text-align:center;color: black !important;"> -0,105 </td>
   <td style="text-align:center;color: black !important;"> 0,205 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 8 </td>
   <td style="text-align:center;"> 0,868 </td>
   <td style="text-align:center;"> 0,8 </td>
   <td style="text-align:center;"> 0,868 </td>
   <td style="text-align:center;color: black !important;"> -0,068 </td>
   <td style="text-align:center;color: black !important;"> 0,168 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 9 </td>
   <td style="text-align:center;"> 0,885 </td>
   <td style="text-align:center;"> 0,9 </td>
   <td style="text-align:center;"> 0,885 </td>
   <td style="text-align:center;color: black !important;"> 0,015 </td>
   <td style="text-align:center;color: black !important;"> 0,085 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 10 </td>
   <td style="text-align:center;"> 0,912 </td>
   <td style="text-align:center;"> 1,0 </td>
   <td style="text-align:center;"> 0,912 </td>
   <td style="text-align:center;font-weight: bold;color: red !important;"> 0,088 </td>
   <td style="text-align:center;color: black !important;"> 0,012 </td>
  </tr>
</tbody>
</table>
<br/>

Como se observa en la tabla \@ref(tab:datos7) $D_{n}^{+} = 0,088$ y $D_{n}^{-} = 0,336$. En consecuencia, el _estadístico bilateral de Kolgomoro-Smirnov_ es $D_{n} = 0,336$. Mientras que $p_{valor} = 0,165092$.

Dado que el $p_{valor}>0,05$ se acepta la hipótesis de que la reflectancia tiene distribución $U(a=0, b=1)$.

Los resultados anterioores se pueden obtener con el siguiente código.


```{.r .watch-out}
D_mas <- max(datos7$D_mas)
D_menos <- max(datos7$D_menos)
Dn <- max(D_mas, D_menos)
p.valor <- 1 - pkolmim(d = Dn, n = length(reflectancia))
paste("El valor de estadístico Dn_mas =", D_mas)
paste("El valor de estadístico Dn_menos =", D_menos)
paste("El valor de estadístico Dn =", Dn)
paste("El p.valor =", p.valor)
```

```{.bg-warning}
#> [1] "El valor de estadístico Dn_mas = 0.088"
#> [1] "El valor de estadístico Dn_menos = 0.336"
#> [1] "El valor de estadístico Dn = 0.336"
#> [1] "El p.valor = 0.165092038878279"
```
<br/>

La figura \@ref(fig:distribucion-reflectancia), generada por el código que se presenta luego, compara la gráfica de la función de distribución acumulada empíricas  de la muestra y la distribución $U(a=0, b=1)$.


```{.r .watch-out}
ggplot(as.data.frame(reflectancia), aes(x = reflectancia)) +
  xlim(0, 1) +
  stat_ecdf(
    aes(colour = "Distribución empírica"),
    geom = "step", color = "steelblue"
  ) +
  stat_ecdf(geom = "point", color = "black") +
  stat_function(
    aes(colour = "Distribución uniforme"),
    fun = punif, color = "red",
    args = list(min = 0, max = 1)
  ) +
  labs(
    x = "Reflectancia",
    y = "Distribución acumulada"
  ) +
  theme(legend.position = "top") +
  theme_minimal() +
  theme(
    panel.grid.major = element_line(
      colour = "lightsteelblue1",
      size = 0.25, linetype = "twodash"
    ),
    axis.title = element_text(face = "bold.italic"),
    panel.background = element_rect(fill = "white", linetype = "solid"),
    plot.background = element_rect(fill = "antiquewhite", colour = NA)
  ) +
  theme(
    axis.line = element_line(
      colour = NA,
      linetype = "solid"
    ), axis.title = element_text(size = 10),
    axis.text.x = element_text(size = 9),
    axis.text.y = element_text(size = 9),
    plot.title = element_text(size = 12),
    plot.background = element_rect(fill = "antiquewhite1")
  )
```

<div class="figure">
<img src="_main_files/figure-html/distribucion-reflectancia-1.png" alt="Función de distribución acumulada empírica de la reflectancia" width="672" />
<p class="caption">(\#fig:distribucion-reflectancia)Función de distribución acumulada empírica de la reflectancia</p>
</div>




Luego, la ejecución del siguiente código muestra la prueba de bondad de ajuste Kolmogorov-Smirnov, para determinar si la muestra obtenida de la variable reflectancia se puede modelar por la distribución uniforme estándar.


```{.r .watch-out}
ks.test(reflectancia, "punif",
  min = 0, max = 1,
  alternative = "two.sided"
)
```

```{.bg-warning}
#> 
#> 	One-sample Kolmogorov-Smirnov test
#> 
#> data:  reflectancia
#> D = 0.336, p-value = 0.1651
#> alternative hypothesis: two-sided
```
<br/> 

Note que los valores $D_n$ y el $p_{valor}$ obtenidos en esta salida coinciden con los anteriores.

**Ejemplo 8:** La prueba de bondad de ajuste Chi-Cuadrada aplicada en el ejemplo 5 mostró que la longitud de la pieza no se distribuyen normalmente con media 10,5 y desviación estándar 0,15. A continuación se procede a verificar esta conclusión aplicando la _prueba de bondad de ajuste Kolmogorov-Smirnov_.

La tabla \@ref(tab:datos8) muestra la función de distribución acumulada empíricas y la función de distribución acumulada propuesta en $H_0$.


```{.r .watch-out}
lp <- c(
  10.39, 10.66, 10.12, 10.32, 10.25, 10.91, 10.52, 10.83,
  10.72, 10.28, 10.35, 10.46, 10.54, 10.72, 10.23, 10.18,
  10.62, 10.49, 10.32, 10.61, 10.64, 10.23, 10.29, 10.78,
  10.81, 10.39, 10.34, 10.62, 10.75, 10.34, 10.41, 10.81,
  10.64, 10.53, 10.31, 10.46, 10.47, 10.43, 10.57, 10.74
)
Xi <- sort(unique(lp))
i <- numeric(length(Xi))
for (j in 1:length(Xi)) {
  i[j] <- sum(lp <= Xi[j])
}
datos8 <- data.frame(
  i = i,
  Xi = Xi
) %>%
  mutate(
    Fn = i / length(lp),
    F0 = pnorm(q = Xi, mean = 10.5, sd = 0.15),
    D_mas = Fn - F0,
    D_menos = F0 - (i - 1) / length(lp)
  )
kableExtra::kbl(
  datos8,
  digits = 4,
  booktabs = TRUE,
  row.names = NA,
  col.names = c(
    "$i$",
    "$x_{\\left( i \\right)}$",
    "$F_{n}^{*}\\left( x_{\\left( i \\right)} \\right)$",
    "$F_{0}\\left( x_{\\left( i \\right)} \\right)$",
    "$D_{n}^{+}$",
    "$D_{n}^{-}$"
  ),
  align = c("c", "c", "c", "c", "c", "c"),
  format.args = list(decimal.mark = ",", big.mark = "."),
  caption = "\\label{tab2:datos7}Distribución empírica de la longitud de la pieza Vs la distribución $N\\left(\\mu=10,5;\\, \\sigma =0,15 \\right)$",
  escape = FALSE
) %>%
  kable_styling(
    bootstrap_options = "striped",
    full_width = FALSE,
    fixed_thead = T
  ) %>%
  column_spec(
    5,
    color = if_else(datos8$D_mas == max(datos8$D_mas), "red", "black"),
    bold = if_else(datos8$D_mas == max(datos8$D_mas), TRUE, FALSE)
  ) %>%
  column_spec(
    6,
    color = if_else(datos8$D_menos == max(datos8$D_menos), "red", "black"),
    bold = if_else(datos8$D_menos == max(datos8$D_menos), TRUE, FALSE)
  ) %>%
  kable_classic_2() %>%
  scroll_box(width = "100%", height = "400px")
```

<div style="border: 1px solid #ddd; padding: 0px; overflow-y: scroll; height:400px; overflow-x: scroll; width:100%; "><table class="table table-striped lightable-classic-2" style='width: auto !important; margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
<caption>(\#tab:datos8)\label{tab2:datos7}Distribución empírica de la longitud de la pieza Vs la distribución $N\left(\mu=10,5;\, \sigma =0,15 \right)$</caption>
 <thead>
  <tr>
   <th style="text-align:center;position: sticky; top:0; background-color: #FFFFFF;position: sticky; top:0; background-color: #FFFFFF;"> $i$ </th>
   <th style="text-align:center;position: sticky; top:0; background-color: #FFFFFF;position: sticky; top:0; background-color: #FFFFFF;"> $x_{\left( i \right)}$ </th>
   <th style="text-align:center;position: sticky; top:0; background-color: #FFFFFF;position: sticky; top:0; background-color: #FFFFFF;"> $F_{n}^{*}\left( x_{\left( i \right)} \right)$ </th>
   <th style="text-align:center;position: sticky; top:0; background-color: #FFFFFF;position: sticky; top:0; background-color: #FFFFFF;"> $F_{0}\left( x_{\left( i \right)} \right)$ </th>
   <th style="text-align:center;position: sticky; top:0; background-color: #FFFFFF;position: sticky; top:0; background-color: #FFFFFF;"> $D_{n}^{+}$ </th>
   <th style="text-align:center;position: sticky; top:0; background-color: #FFFFFF;position: sticky; top:0; background-color: #FFFFFF;"> $D_{n}^{-}$ </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 10,12 </td>
   <td style="text-align:center;"> 0,025 </td>
   <td style="text-align:center;"> 0,0056 </td>
   <td style="text-align:center;color: black !important;"> 0,0194 </td>
   <td style="text-align:center;color: black !important;"> 0,0056 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 10,18 </td>
   <td style="text-align:center;"> 0,050 </td>
   <td style="text-align:center;"> 0,0164 </td>
   <td style="text-align:center;color: black !important;"> 0,0336 </td>
   <td style="text-align:center;color: black !important;"> -0,0086 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4 </td>
   <td style="text-align:center;"> 10,23 </td>
   <td style="text-align:center;"> 0,100 </td>
   <td style="text-align:center;"> 0,0359 </td>
   <td style="text-align:center;color: black !important;"> 0,0641 </td>
   <td style="text-align:center;color: black !important;"> -0,0391 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 5 </td>
   <td style="text-align:center;"> 10,25 </td>
   <td style="text-align:center;"> 0,125 </td>
   <td style="text-align:center;"> 0,0478 </td>
   <td style="text-align:center;color: black !important;"> 0,0772 </td>
   <td style="text-align:center;color: black !important;"> -0,0522 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 6 </td>
   <td style="text-align:center;"> 10,28 </td>
   <td style="text-align:center;"> 0,150 </td>
   <td style="text-align:center;"> 0,0712 </td>
   <td style="text-align:center;color: black !important;"> 0,0788 </td>
   <td style="text-align:center;color: black !important;"> -0,0538 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 7 </td>
   <td style="text-align:center;"> 10,29 </td>
   <td style="text-align:center;"> 0,175 </td>
   <td style="text-align:center;"> 0,0808 </td>
   <td style="text-align:center;color: black !important;"> 0,0942 </td>
   <td style="text-align:center;color: black !important;"> -0,0692 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 8 </td>
   <td style="text-align:center;"> 10,31 </td>
   <td style="text-align:center;"> 0,200 </td>
   <td style="text-align:center;"> 0,1026 </td>
   <td style="text-align:center;color: black !important;"> 0,0974 </td>
   <td style="text-align:center;color: black !important;"> -0,0724 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 10 </td>
   <td style="text-align:center;"> 10,32 </td>
   <td style="text-align:center;"> 0,250 </td>
   <td style="text-align:center;"> 0,1151 </td>
   <td style="text-align:center;color: black !important;"> 0,1349 </td>
   <td style="text-align:center;color: black !important;"> -0,1099 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 12 </td>
   <td style="text-align:center;"> 10,34 </td>
   <td style="text-align:center;"> 0,300 </td>
   <td style="text-align:center;"> 0,1431 </td>
   <td style="text-align:center;color: black !important;"> 0,1569 </td>
   <td style="text-align:center;color: black !important;"> -0,1319 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 13 </td>
   <td style="text-align:center;"> 10,35 </td>
   <td style="text-align:center;"> 0,325 </td>
   <td style="text-align:center;"> 0,1587 </td>
   <td style="text-align:center;font-weight: bold;color: red !important;"> 0,1663 </td>
   <td style="text-align:center;color: black !important;"> -0,1413 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 15 </td>
   <td style="text-align:center;"> 10,39 </td>
   <td style="text-align:center;"> 0,375 </td>
   <td style="text-align:center;"> 0,2317 </td>
   <td style="text-align:center;color: black !important;"> 0,1433 </td>
   <td style="text-align:center;color: black !important;"> -0,1183 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 16 </td>
   <td style="text-align:center;"> 10,41 </td>
   <td style="text-align:center;"> 0,400 </td>
   <td style="text-align:center;"> 0,2743 </td>
   <td style="text-align:center;color: black !important;"> 0,1257 </td>
   <td style="text-align:center;color: black !important;"> -0,1007 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 17 </td>
   <td style="text-align:center;"> 10,43 </td>
   <td style="text-align:center;"> 0,425 </td>
   <td style="text-align:center;"> 0,3204 </td>
   <td style="text-align:center;color: black !important;"> 0,1046 </td>
   <td style="text-align:center;color: black !important;"> -0,0796 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 19 </td>
   <td style="text-align:center;"> 10,46 </td>
   <td style="text-align:center;"> 0,475 </td>
   <td style="text-align:center;"> 0,3949 </td>
   <td style="text-align:center;color: black !important;"> 0,0801 </td>
   <td style="text-align:center;color: black !important;"> -0,0551 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 20 </td>
   <td style="text-align:center;"> 10,47 </td>
   <td style="text-align:center;"> 0,500 </td>
   <td style="text-align:center;"> 0,4207 </td>
   <td style="text-align:center;color: black !important;"> 0,0793 </td>
   <td style="text-align:center;color: black !important;"> -0,0543 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 21 </td>
   <td style="text-align:center;"> 10,49 </td>
   <td style="text-align:center;"> 0,525 </td>
   <td style="text-align:center;"> 0,4734 </td>
   <td style="text-align:center;color: black !important;"> 0,0516 </td>
   <td style="text-align:center;color: black !important;"> -0,0266 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 22 </td>
   <td style="text-align:center;"> 10,52 </td>
   <td style="text-align:center;"> 0,550 </td>
   <td style="text-align:center;"> 0,5530 </td>
   <td style="text-align:center;color: black !important;"> -0,0030 </td>
   <td style="text-align:center;color: black !important;"> 0,0280 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 23 </td>
   <td style="text-align:center;"> 10,53 </td>
   <td style="text-align:center;"> 0,575 </td>
   <td style="text-align:center;"> 0,5793 </td>
   <td style="text-align:center;color: black !important;"> -0,0043 </td>
   <td style="text-align:center;color: black !important;"> 0,0293 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 24 </td>
   <td style="text-align:center;"> 10,54 </td>
   <td style="text-align:center;"> 0,600 </td>
   <td style="text-align:center;"> 0,6051 </td>
   <td style="text-align:center;color: black !important;"> -0,0051 </td>
   <td style="text-align:center;color: black !important;"> 0,0301 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 25 </td>
   <td style="text-align:center;"> 10,57 </td>
   <td style="text-align:center;"> 0,625 </td>
   <td style="text-align:center;"> 0,6796 </td>
   <td style="text-align:center;color: black !important;"> -0,0546 </td>
   <td style="text-align:center;color: black !important;"> 0,0796 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 26 </td>
   <td style="text-align:center;"> 10,61 </td>
   <td style="text-align:center;"> 0,650 </td>
   <td style="text-align:center;"> 0,7683 </td>
   <td style="text-align:center;color: black !important;"> -0,1183 </td>
   <td style="text-align:center;font-weight: bold;color: red !important;"> 0,1433 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 28 </td>
   <td style="text-align:center;"> 10,62 </td>
   <td style="text-align:center;"> 0,700 </td>
   <td style="text-align:center;"> 0,7881 </td>
   <td style="text-align:center;color: black !important;"> -0,0881 </td>
   <td style="text-align:center;color: black !important;"> 0,1131 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 30 </td>
   <td style="text-align:center;"> 10,64 </td>
   <td style="text-align:center;"> 0,750 </td>
   <td style="text-align:center;"> 0,8247 </td>
   <td style="text-align:center;color: black !important;"> -0,0747 </td>
   <td style="text-align:center;color: black !important;"> 0,0997 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 31 </td>
   <td style="text-align:center;"> 10,66 </td>
   <td style="text-align:center;"> 0,775 </td>
   <td style="text-align:center;"> 0,8569 </td>
   <td style="text-align:center;color: black !important;"> -0,0819 </td>
   <td style="text-align:center;color: black !important;"> 0,1069 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 33 </td>
   <td style="text-align:center;"> 10,72 </td>
   <td style="text-align:center;"> 0,825 </td>
   <td style="text-align:center;"> 0,9288 </td>
   <td style="text-align:center;color: black !important;"> -0,1038 </td>
   <td style="text-align:center;color: black !important;"> 0,1288 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 34 </td>
   <td style="text-align:center;"> 10,74 </td>
   <td style="text-align:center;"> 0,850 </td>
   <td style="text-align:center;"> 0,9452 </td>
   <td style="text-align:center;color: black !important;"> -0,0952 </td>
   <td style="text-align:center;color: black !important;"> 0,1202 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 35 </td>
   <td style="text-align:center;"> 10,75 </td>
   <td style="text-align:center;"> 0,875 </td>
   <td style="text-align:center;"> 0,9522 </td>
   <td style="text-align:center;color: black !important;"> -0,0772 </td>
   <td style="text-align:center;color: black !important;"> 0,1022 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 36 </td>
   <td style="text-align:center;"> 10,78 </td>
   <td style="text-align:center;"> 0,900 </td>
   <td style="text-align:center;"> 0,9690 </td>
   <td style="text-align:center;color: black !important;"> -0,0690 </td>
   <td style="text-align:center;color: black !important;"> 0,0940 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 38 </td>
   <td style="text-align:center;"> 10,81 </td>
   <td style="text-align:center;"> 0,950 </td>
   <td style="text-align:center;"> 0,9806 </td>
   <td style="text-align:center;color: black !important;"> -0,0306 </td>
   <td style="text-align:center;color: black !important;"> 0,0556 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 39 </td>
   <td style="text-align:center;"> 10,83 </td>
   <td style="text-align:center;"> 0,975 </td>
   <td style="text-align:center;"> 0,9861 </td>
   <td style="text-align:center;color: black !important;"> -0,0111 </td>
   <td style="text-align:center;color: black !important;"> 0,0361 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 40 </td>
   <td style="text-align:center;"> 10,91 </td>
   <td style="text-align:center;"> 1,000 </td>
   <td style="text-align:center;"> 0,9969 </td>
   <td style="text-align:center;color: black !important;"> 0,0031 </td>
   <td style="text-align:center;color: black !important;"> 0,0219 </td>
  </tr>
</tbody>
</table></div>
<br/>

Como se observa en la tabla \@ref(tab:datos8) $D_{n}^{+} = 0,1663447$ y $D_{n}^{-} = 0,1433224$. En consecuencia, el _estadístico bilateral de Kolgomoro-Smirnov_ es $D_{n} = 0,1663447$. Mientras que $p_{valor} = 0,9038855$.

Dado que el $p_{valor} > 0,05$ se acepta la hipótesis de que la longitud de la pieza tiene distribución $N\left(\mu=10,5;\, \sigma =0,15 \right)$.

Los resultados anteriores se pueden obtener con el siguiente código.


```{.r .watch-out}
D_mas <- max(datos8$D_mas)
D_menos <- max(datos8$D_menos)
Dn <- max(D_mas, D_menos)
p.valor <- 1 - pkolmim(d = Dn, n = length(lp))
paste("El valor de estadístico Dn_mas =", D_mas)
paste("El valor de estadístico Dn_menos =", D_menos)
paste("El valor de estadístico Dn =", Dn)
paste("El p.valor =", p.valor)
```

```{.bg-warning}
#> [1] "El valor de estadístico Dn_mas = 0.166344746068544"
#> [1] "El valor de estadístico Dn_menos = 0.143322425365201"
#> [1] "El valor de estadístico Dn = 0.166344746068544"
#> [1] "El p.valor = 0.195116738373406"
```
<br/>

La figura \@ref(fig:distribucion-lp), generada por el código que se presenta luego, compara la gráfica de la función de distribución acumulada empíricas  y la distribución $N\left(\mu=10,5;\, \sigma =0,15 \right)$. Como se nota en esta gráfica, la distribución empírica se ajusta a la distribución  $N\left(\mu=10,5;\, \sigma =0,15 \right)$, representada por la curva roja.


```{.r .watch-out}
ggplot(as.data.frame(lp), aes(x = lp)) +
  stat_ecdf(
    aes(colour = "Distribución empírica"),
    geom = "step", color = "steelblue"
  ) +
  stat_ecdf(geom = "point", color = "black") +
  stat_function(
    aes(colour = "Distribución Normal"),
    fun = pnorm, color = "red",
    args = list(mean = 10.5, sd = 0.15)
  ) +
  labs(
    x = "Longitud de la pieza",
    y = "Distribución acumulada"
  ) +
  theme(legend.position = "top") +
  theme_minimal() +
  theme(
    panel.grid.major = element_line(
      colour = "lightsteelblue1",
      size = 0.25, linetype = "twodash"
    ),
    axis.title = element_text(face = "bold.italic"),
    panel.background = element_rect(fill = "white", linetype = "solid"),
    plot.background = element_rect(fill = "antiquewhite", colour = NA)
  ) +
  theme(
    axis.line = element_line(
      colour = NA,
      linetype = "solid"
    ), axis.title = element_text(size = 10),
    axis.text.x = element_text(size = 9),
    axis.text.y = element_text(size = 9),
    plot.title = element_text(size = 12),
    plot.background = element_rect(fill = "antiquewhite1")
  )
```

<div class="figure">
<img src="_main_files/figure-html/distribucion-lp-1.png" alt="Función de distribución acumulada empírica de la longitud de la  pieza" width="672" />
<p class="caption">(\#fig:distribucion-lp)Función de distribución acumulada empírica de la longitud de la  pieza</p>
</div>

Luego, la ejecución del siguiente código muestra la prueba de bondad de ajuste Kolmogorov-Smirnov, para determinar si la muestra obtenida de la longitud de la pieza se puede modelar por la distribución $N\left(\mu=10,5;\, \sigma =0,15 \right)$.


```{.r .watch-out}
ks.test(lp, "pnorm",
  mean = 10.5, sd = 0.15,
  alternative = "two.sided", exact = TRUE
)
```

```{.bg-warning}
#> 
#> 	One-sample Kolmogorov-Smirnov test
#> 
#> data:  lp
#> D = 0.16634, p-value = 0.1951
#> alternative hypothesis: two-sided
```
<br/>

Note que los valores $D_n$ y  $p_{valor}$ son iguales a los obtenidos anteriormente.

### Problemas Propuestos {#broblemas-KolgomoroSmirnov1}

1)	Un estudiante de estadística desea verificar si es razonable suponer que algunos datos sobre ventas han sido tomados de una población normal antes de llevar a cabo una prueba de hipótesis sobre la media de las ventas. Recoge algunos datos sobre ventas, calcula  $\bar{x}= 78$ y $s = 9$, y tabula los datos de la siguiente manera:
$$
\begin{array}{lcccccc}
\hline
\mathbf{Nivel \, de\,  ventas} &	\leq65 &	66 - 70 &	71 - 75 &	76 - 80 &	81 - 85  &	\geq 86 \\
\mathbf{N^{\circ} \, de\,  observaciones} &	10 &	20 &	40 &	50 &	40  &	40\\
\hline
\end{array}
$$
	a) ¿Es importante para el estudiante de estadística verificar si los datos están distribuidos normalmente? Explique su respuesta.
	b) Al nivel de significancia de 5\%. ¿la distribución de frecuencias observada sigue una distribución normal $\bar{x}= 78$ y $s = 9$?
	
2)	Se utiliza un proceso de plateado para cubrir cierto tipo de charola de servicio. Cuando el proceso está bajo control el espesor de la plata sobre la charola variara de forma aleatoria siguiendo una distribución normal con una media de 0,02 milímetros y una desviación estándar de 0,005 milímetros. Suponga que las siguientes 12 charolas examinadas muestran los siguientes espesores de plata: 0,019; 0,021; 0,020; 0,019; 0,020; 0,018; 0,023; 0,021; 0,024; 0,022; 0,023; 0,022. Utilice la prueba de Kolmogorov-Smirnov para determinar si está bajo control. Utilice $\alpha= 0,05$.


##	Prueba de Rachas o Carreras de Walf-Wolfowits {#rachas1}

Si un investigador desea llegar a alguna conclusión acerca de una población usando la información contenida en una muestra extraída de esa población, entonces la muestra debe ser aleatoria; es decir, las observaciones sucesivas deben ser independientes. En este sentido la prueba de la racha o carrera se usa para probar la hipótesis de que una muestra tomada de una población es aleatoria.

###	Racionalización de la Prueba de Rachas o Carreras de Walf-Wolfowits {#racionalizacion-rachas1}

La prueba de la racha está basada en el número de rachas, corridas, carreras o series que exhibe una muestra. Una racha se define como una sucesión de símbolos idénticos que son seguidos y precedidos por diferentes símbolos o por ningún símbolo. Por ejemplo, supóngase que se tiene una población que se ha codificada en forma binaria, es decir solo puede tomar los valores 0 ó 1, y que se presentan las muestras

$$
\begin{array}{cc}
00000000111111 &	\acute{o} &	10101010101010	\\
\end{array}
$$

no cabe duda de que tienen un aspecto poco aleatorio y que cabe dudar de que se hayan observado en condiciones aleatorias. En cambio, la sospecha no surgiría, por ejemplo, ante las muestras:

$$
\begin{array}{cc}
10011100110001 &	\acute{o} &	01110010000111	\\
\end{array}
$$

Ante el desconocimiento de la distribución poblacional (en este caso, de las proporciones de 0 y 1 que debería presentarse) el único rasgo por el que se puede diferenciar la poca aleatoriedad de las primeras respecto de las segundas es por la colocación de los dígitos y, más exactamente, por el número, $R$, de rachas de cada uno que haya presentes. Así, en la primera es $R=2$, en la segunda $R=14$, es $R=7$ y $R=6$ en las dos últimas.

Naturalmente son más las secuencias con un número intermedio de rachas que con un número extremo, de forma que una secuencia elegida al azar contendrá, muy probablemente, un número intermedio de rachas. En tal sentido, regiones críticas de la forma

$$
\left\{ R< k_{1}\right\} \cup \left\{R> k_{2} \right\}
$$

sirven entonces como test para el contraste de la hipótesis de que la muestra es aleatoria simple.

Suponga de manera general, que en la muestra de tamaño $n$ hay $n_1$ elementos de una clase y $n_2$ elementos de otra clase, es decir la muestra consta de $n =n_1 + n_2$ elementos binarios. Entonces, la distribución de $R$, bajo $H_0$, se puede hallar explícitamente por:

$$
\begin{equation}
\left.\begin{matrix}
P\left\{ R=2r\right\}=2 \frac{\binom{n_{1} - 1}{r-1} \binom{n_{2}-1}{r-1}}{\binom{n}{n_{1}}} \\
P\left\{ R=2r +1\right\}= \frac{\binom{n_{1} - 1}{r-1} \binom{n_{2}-1}{r}+\binom{n_{1}-1}{r}\binom{n_{2}-1}{r-1}}{\binom{n}{n_{1}}}
\end{matrix}\right\}para \: r \: mín\left ( n_{1},n_{2} \right ). 
(\#eq:fmp-ranks)
\end{equation}
$$

En efecto, $n_1$ elementos de una clase y $n_2$ elementos de la otra clase pueden ordenarse de $(n_1+n_2 )!=n!$ maneras, igualmente probables. Para formar secuencias con $r$ rachas de elementos de una clase y $r$ rachas de la otra clase, los elementos de la primera clase se pueden ordenar de $n_1!$ formas, dividiéndose luego $r$ en grupos, mediante la elección de $r-1$ de los $n_1-1$ huecos existentes entre ellos.

Análogamente, los elementos de la segunda clase pueden ser ordenados de $n_2 !$ maneras y divididos en $r$ grupos de $\binom{n_{2}-1}{r-1}$ formas. Después hay que intercambiar los grupos formados, empezando con el primer grupo de elementos de la primera clase, o bien con el primer grupo de elementos de la segunda clase. En total, la probabilidad de que haya $r$ rachas de cada tipo es

$$
\frac{n!\binom{n_1 -1}{r-1}n_2!\binom{n_2-1}{r-1}}{\left ( n_1 + n_2 \right )!}=2 \frac{\binom{n_{1} - 1}{r-1} \binom{n_{2}-1}{r-1}}{\binom{n}{n_{1}}}.
$$

De manera similar se calcula la probabilidad de que haya $r$ rachas de elementos de la primera clase y $r+1$ rachas de elementos de la segunda clase y la probabilidad de que haya $r+1$ rachas de elementos de la primera clase y $r$ rachas de elementos de la segunda clase, las cuales dan lugar a los dos sumandos de la segunda ecuación de la expresión \@ref(eq:fmp-ranks). (Naturalmente, el número de rachas de un tipo y otro se diferencian, a lo sumo, en 1).

Si $n_1$ y $n_2$ son grandes (superiores a 20), puede probarse que 

$$
R\simeq N\left ( \mu_R =\frac{2n_1n_2}{n} +1,\sigma_R=\sqrt{\frac{2n_1n_2\left ( 2n_1n_2-n \right )}{n^{2}\left ( n-1 \right )}} \right ).
$$

De donde se establece que el estadístico

$$
\begin{equation}
Z=\frac{R+h-\frac{2n_1n_2}{n} -1}{\sqrt{\frac{2n_1n_2\left ( 2n_1n_2-n \right )}{n^{2}\left ( n-1 \right )}}}\simeq N\left(\mu_Z=0, \sigma_Z=1 \right). 
(\#eq:dranks-aprox)
\end{equation}
$$

Donde $h=+0,5$ si $r<(2n_1 n_2)⁄n \,+1$, y $h=-0,5$ si $r>(2n_1 n_2)⁄n\,+1$.

Para contrastar la hipótesis nula $H_0:$ la cual representa que la muestra es aleatoria usando el estadístico $R$ es necesario determinar el valor crítico de $R$ para un nivel de significancia $\alpha$ especificado y los valores de los parámetros $n_1$ y $n_2$, determinados a partir de la muestra. En la literatura existen diversas tablas que proporcionan estos valores, generalmente para $n_1, n_2 \leq20$. Otra forma de contrastar $H_0$ es a través del $p_{valor}$ calculado por medio de la función de distribución acumulada de $R$.

El paquete `randtests` proporciona las siguientes funciones relacionadas con la distribución de las rachas:

*  `druns(x, n1, n2, log = FALSE)`
*  `pruns(q, n1, n2, lower.tail = TRUE, log.p = FALSE)`
*  `qruns(p, n1, n2, lower.tail = TRUE, log.p = FALSE)`
*  `rruns(n, n1, n2)` 

La función `druns` determina la función de masa de probabilidad de $R$, la función `pruns` evalúa la función de distribución de $R$, la función `qruns` determina valores críticos de $R$ y `rruns` genera números aleatorios de $R$. Los parámetros de estas funciones se describen en la tabla \@ref(tab:par-dist-runs).

(ref:foo10) Descripción de los parámetros de funciones de <span style='color: blue;'>R</span> relacionadas con la distribución de las rachas


```{.r .watch-out}
knitr::kable(
  data.frame(
    stringsAsFactors = FALSE,
    Parámetros = c(
      "x, q", "p", "n",
      "n1, n2", "log, log.p", "lower.tail"
    ),
    Descripción = c(
      "Vector numérico de cuantiles", "Vector numérico de probabilidades",
      "Número valores aleatorios de rachas a generar",
      "El número de elementos del primer y segundo tipo, respectivamente",
      "Lógico; si es TRUE, las probabilidades p se dan como log(p)",
      "Lógico; si es TRUE (por defecto), las probabilidades son $P[X     \\leq x]$, de lo contrario, $P[X > x]$"
    )
  ),
  booktabs = TRUE,
  caption = "(ref:foo10)",
  escape = FALSE
) %>%
  kable_styling(
    bootstrap_options = "striped",
    full_width = FALSE,
    fixed_thead = T
  ) %>%
  kable_classic_2()
```

<table class="table table-striped lightable-classic-2" style='width: auto !important; margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
<caption>(\#tab:par-dist-runsks)(ref:foo10)</caption>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> Parámetros </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> Descripción </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> x, q </td>
   <td style="text-align:left;"> Vector numérico de cuantiles </td>
  </tr>
  <tr>
   <td style="text-align:left;"> p </td>
   <td style="text-align:left;"> Vector numérico de probabilidades </td>
  </tr>
  <tr>
   <td style="text-align:left;"> n </td>
   <td style="text-align:left;"> Número valores aleatorios de rachas a generar </td>
  </tr>
  <tr>
   <td style="text-align:left;"> n1, n2 </td>
   <td style="text-align:left;"> El número de elementos del primer y segundo tipo, respectivamente </td>
  </tr>
  <tr>
   <td style="text-align:left;"> log, log.p </td>
   <td style="text-align:left;"> Lógico; si es TRUE, las probabilidades p se dan como log(p) </td>
  </tr>
  <tr>
   <td style="text-align:left;"> lower.tail </td>
   <td style="text-align:left;"> Lógico; si es TRUE (por defecto), las probabilidades son $P[X     \leq x]$, de lo contrario, $P[X > x]$ </td>
  </tr>
</tbody>
</table>
<br/>

Por otro lado, la función `runs.test(x, alternative, threshold, pvalue, plot)` del paquete `randtests`, permite aplicar la _prueba de las rachas de Walf-Wolfowits_. Los parámetros de esta función se especifican en la tabla \@ref(tab:par-runstest).


```{.r .watch-out}
knitr::kable(
  data.frame(
    stringsAsFactors = FALSE,
    Parámetros = c("x", "alternative", "threshold", "pvalue", "plot"),
    Descripción = c(
      "Vector numérico que contiene las observaciones",
      "Cadena de caracteres indicando la hipótesis alternativa. Puede tomar los valores: \"two.sided\" (por defecto), \"left.sided\" o \"right.sided\". Puede especificar sólo la letra inicial",
      "El punto de corte para transformar los datos en un vector dicotómico. Por defecto toma el valor de la mediana de x",
      "Cadena de caracteres que especifica el método utilizado para calcular el valor p. Puede ser normal (por defecto), o exacto",
      "Valor lógico para indicar si se debe crear un gráfico. Si es 'TRUE', entonces el gráfico será graficado"
    )
  ),
  booktabs = TRUE,
  caption = "\\label{tab2:par-runstest}Descripción de los parámetros de función `runs.test`",
  escape = FALSE
) %>%
  kable_styling(
    bootstrap_options = "striped",
    full_width = FALSE,
    fixed_thead = T
  ) %>%
  kable_classic_2()
```

<table class="table table-striped lightable-classic-2" style='width: auto !important; margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
<caption>(\#tab:par-runstest)\label{tab2:par-runstest}Descripción de los parámetros de función `runs.test`</caption>
 <thead>
  <tr>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> Parámetros </th>
   <th style="text-align:left;position: sticky; top:0; background-color: #FFFFFF;"> Descripción </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> x </td>
   <td style="text-align:left;"> Vector numérico que contiene las observaciones </td>
  </tr>
  <tr>
   <td style="text-align:left;"> alternative </td>
   <td style="text-align:left;"> Cadena de caracteres indicando la hipótesis alternativa. Puede tomar los valores: "two.sided" (por defecto), "left.sided" o "right.sided". Puede especificar sólo la letra inicial </td>
  </tr>
  <tr>
   <td style="text-align:left;"> threshold </td>
   <td style="text-align:left;"> El punto de corte para transformar los datos en un vector dicotómico. Por defecto toma el valor de la mediana de x </td>
  </tr>
  <tr>
   <td style="text-align:left;"> pvalue </td>
   <td style="text-align:left;"> Cadena de caracteres que especifica el método utilizado para calcular el valor p. Puede ser normal (por defecto), o exacto </td>
  </tr>
  <tr>
   <td style="text-align:left;"> plot </td>
   <td style="text-align:left;"> Valor lógico para indicar si se debe crear un gráfico. Si es 'TRUE', entonces el gráfico será graficado </td>
  </tr>
</tbody>
</table>
<br/>

### Implementación en <span style='color: blue;'>R</span> de la Prueba de Rachas o Carreras de Walf-Wolfowits {#R-rachas1}

**Ejemplo 9:** En un estudio de la dinámica de agresión en niños pequeños, un investigador observó pares de niños en una situación de juego controlada. La mayoría de los 24 niños que sirvieron como sujetos en el estudio provenía de la misma guardería y, por lo tanto, jugaban juntos diariamente. Ya que el observador fue capaz de ingeniarse para observar sólo dos niños en cualquier día, estaba interesado en que podría haberse introducido sesgo en el estudio por discusiones entre aquellos niños que ya habían servido como sujetos y aquellos que sirvieron posteriormente. Si tales discusiones tenían algún efecto en el nivel de agresión en las sesiones de juego, este efecto podría mostrarse como una carencia de aleatoriedad en las puntuaciones de agresión en el orden en que fueron colectadas. Después de concluir el estudio, la aleatoriedad de la secuencia de puntuaciones fue probada al convertir las puntuaciones de agresión de cada niño a un signo más o a un signo menos, dependiendo si se encontraba por arriba o por debajo de la mediana del grupo. Los datos se muestran en la tabla \@ref(tab:datos9).


```{.r .watch-out}
puntuacion <- c(
  31L, 23L, 36L, 43L, 51L, 44L, 12L, 26L, 43L, 75L, 2L, 3L, 15L, 18L,
  78L, 24L, 13L, 27L, 86L, 61L, 13L, 7L, 6L, 8L
)
datos9 <- data.frame(
  niños = 1:length(puntuacion),
  puntuacion = puntuacion
) %>%
  mutate(
    signo = as.factor(
      case_when(
        puntuacion > median(puntuacion, na.rm = TRUE) ~ "\\+",
        puntuacion == median(puntuacion, na.rm = TRUE) ~ "=",
        puntuacion < median(puntuacion, na.rm = TRUE) ~ "\\-"
      )
    )
  )
kableExtra::kbl(
  datos9,
  digits = 4,
  booktabs = TRUE,
  row.names = NA,
  col.names = c(
    "Niños",
    "Puntuación",
    "Posición de la puntuación con respecto a la mediana "
  ),
  align = c("c", "c", "c"),
  format.args = list(decimal.mark = ",", big.mark = "."),
  caption = "\\label{tab2:datos9}Puntuaciones de agresión de acuerdo al
orden de ocurrencia",
  escape = FALSE
) %>%
  kable_styling(
    bootstrap_options = "striped",
    full_width = FALSE,
    fixed_thead = T
  ) %>%
  kable_classic_2() %>%
  scroll_box(width = "100%", height = "400px")
```

<div style="border: 1px solid #ddd; padding: 0px; overflow-y: scroll; height:400px; overflow-x: scroll; width:100%; "><table class="table table-striped lightable-classic-2" style='width: auto !important; margin-left: auto; margin-right: auto; font-family: "Arial Narrow", "Source Sans Pro", sans-serif; margin-left: auto; margin-right: auto;'>
<caption>(\#tab:datos9)\label{tab2:datos9}Puntuaciones de agresión de acuerdo al
orden de ocurrencia</caption>
 <thead>
  <tr>
   <th style="text-align:center;position: sticky; top:0; background-color: #FFFFFF;position: sticky; top:0; background-color: #FFFFFF;"> Niños </th>
   <th style="text-align:center;position: sticky; top:0; background-color: #FFFFFF;position: sticky; top:0; background-color: #FFFFFF;"> Puntuación </th>
   <th style="text-align:center;position: sticky; top:0; background-color: #FFFFFF;position: sticky; top:0; background-color: #FFFFFF;"> Posición de la puntuación con respecto a la mediana  </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> 1 </td>
   <td style="text-align:center;"> 31 </td>
   <td style="text-align:center;"> \+ </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> 23 </td>
   <td style="text-align:center;"> \- </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:center;"> 36 </td>
   <td style="text-align:center;"> \+ </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 4 </td>
   <td style="text-align:center;"> 43 </td>
   <td style="text-align:center;"> \+ </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 5 </td>
   <td style="text-align:center;"> 51 </td>
   <td style="text-align:center;"> \+ </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 6 </td>
   <td style="text-align:center;"> 44 </td>
   <td style="text-align:center;"> \+ </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 7 </td>
   <td style="text-align:center;"> 12 </td>
   <td style="text-align:center;"> \- </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 8 </td>
   <td style="text-align:center;"> 26 </td>
   <td style="text-align:center;"> \+ </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 9 </td>
   <td style="text-align:center;"> 43 </td>
   <td style="text-align:center;"> \+ </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 10 </td>
   <td style="text-align:center;"> 75 </td>
   <td style="text-align:center;"> \+ </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 11 </td>
   <td style="text-align:center;"> 2 </td>
   <td style="text-align:center;"> \- </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 12 </td>
   <td style="text-align:center;"> 3 </td>
   <td style="text-align:center;"> \- </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 13 </td>
   <td style="text-align:center;"> 15 </td>
   <td style="text-align:center;"> \- </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 14 </td>
   <td style="text-align:center;"> 18 </td>
   <td style="text-align:center;"> \- </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 15 </td>
   <td style="text-align:center;"> 78 </td>
   <td style="text-align:center;"> \+ </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 16 </td>
   <td style="text-align:center;"> 24 </td>
   <td style="text-align:center;"> \- </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 17 </td>
   <td style="text-align:center;"> 13 </td>
   <td style="text-align:center;"> \- </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 18 </td>
   <td style="text-align:center;"> 27 </td>
   <td style="text-align:center;"> \+ </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 19 </td>
   <td style="text-align:center;"> 86 </td>
   <td style="text-align:center;"> \+ </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 20 </td>
   <td style="text-align:center;"> 61 </td>
   <td style="text-align:center;"> \+ </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 21 </td>
   <td style="text-align:center;"> 13 </td>
   <td style="text-align:center;"> \- </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 22 </td>
   <td style="text-align:center;"> 7 </td>
   <td style="text-align:center;"> \- </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 23 </td>
   <td style="text-align:center;"> 6 </td>
   <td style="text-align:center;"> \- </td>
  </tr>
  <tr>
   <td style="text-align:center;"> 24 </td>
   <td style="text-align:center;"> 8 </td>
   <td style="text-align:center;"> \- </td>
  </tr>
</tbody>
</table></div>
Los datos fueron tomados de Siegel (2012, pág. 85).

El siguiente trozo de código permite determinar el valor del estadístico $R$, el $p_{valor}$, la media y la varianza de $R$.


```{.r .watch-out}
mediana <- datos9 %>%
  pull(puntuacion) %>%
  median(., na.rm = TRUE)
n1 <- datos9 %>%
  dplyr::filter(signo == "\\+") %>%
  pull(signo) %>%
  as.character(.) %>%
  length(.)
n2 <- datos9 %>%
  dplyr::filter(signo == "\\-") %>%
  pull(signo) %>%
  as.character(.) %>%
  length(.)
n <- n1 + n2
rachas <- rle(sign(na.omit(puntuacion) - mediana))
rachas9 <- as.data.frame.list(rachas) %>%
  dplyr::rename(
    lonjitud = lengths,
    signo = values
  )
r1 <- rachas9 %>%
  dplyr::filter(
    signo == 1
  ) %>%
  nrow(.)
r2 <- rachas9 %>%
  dplyr::filter(
    signo == -1
  ) %>%
  nrow(.)
r <- r1 + r2
mu_R <- 2 * n1 * n2 / n + 1
var_R <- 2 * n1 * n2 * (2 * n1 * n2 - n) / (n^2 * (n - 1))
p.valor <- 2 * pruns(q = r, n1 = n1, n2 = n2)
paste("La media del estadístico R =", mu_R)
paste("La varianza del estadístico R =", var_R)
paste("El valor del estadístico R =", r)
paste("El p.valor =", round(x = p.valor, digits = 4))
```

```{.bg-warning}
#> [1] "La media del estadístico R = 13"
#> [1] "La varianza del estadístico R = 5.73913043478261"
#> [1] "El valor del estadístico R = 10"
#> [1] "El p.valor = 0.3009"
```
<br/>

Note en la salida anterior que el valor del estadístico $R = 10$. Mientras que, el $p_{valor} = 0.3008894$, por lo tanto las puntuaciones de agresión de acuerdo al orden en que fueron colectadas tienen un comportamiento aleatorio, lo que implica que las discusiones no tienen efecto en el nivel de agresión en las sesiones de juego.

La figura \@ref(fig:rachas9) muestra la gráfica de las rachas por debajo y por arriba de la mediana de la muestra (linea horizontal roja). Y esta se observa que las longitudes de las rachas tienen un comportamiento aleatorio,  lo cual contrasta con la conclusión anterior.  


```{.r .watch-out}
ggplot(datos9, aes(x = niños, y = puntuacion)) +
  geom_point(aes(colour = as.factor(signo)), size = 2) +
  geom_vline(
    xintercept = rachas9 %>%
      dplyr::select(lonjitud) %>%
      dplyr::slice(1:nrow(.) - 1) %>%
      dplyr::pull(lonjitud) %>%
      cumsum(.) + 0.5,
    color = "steelblue",
    linetype = "dashed",
    size = 1
  ) +
  geom_hline(
    yintercept = mediana,
    color = "red",
    linetype = "solid",
    size = 1
  ) +
  labs(
    x = "Niños",
    y = "Puntuación"
  ) +
  theme_minimal() +
  scale_colour_brewer(palette = "Set1") +
  theme(
    panel.grid.major = element_line(
      colour = "lightsteelblue1",
      size = 0.25, linetype = "twodash"
    ),
    axis.title = element_text(face = "bold.italic"),
    panel.background = element_rect(fill = "white", linetype = "solid"),
    plot.background = element_rect(fill = "antiquewhite", colour = NA)
  ) +
  theme(
    axis.line = element_line(
      colour = NA,
      linetype = "solid"
    ), axis.title = element_text(size = 10),
    axis.text.x = element_text(size = 9),
    axis.text.y = element_text(size = 9),
    plot.title = element_text(size = 12),
    plot.background = element_rect(fill = "antiquewhite1"),
    legend.position = "NULL"
  )
```

<div class="figure">
<img src="_main_files/figure-html/rachas9-1.png" alt="Rachas para las puntuaciones de agresión de acuerdo al orden de ocurrencia" width="672" />
<p class="caption">(\#fig:rachas9)Rachas para las puntuaciones de agresión de acuerdo al orden de ocurrencia</p>
</div>

<span style='color: blue;'>R</span> tiene implementadas muchas funciones que ejecutan la _prueba de Rachas o Carreras de Walf-Wolfowits_. Una de ellas es la función `runs.test` del paquete `randtests`, cuyos parámetros se definen en la tabla \@ref(tab:par-runstest). El siguiente script ejecuta la prueba para contrastar la hipótesis de aleatoriedad de la muestra.


```{.r .watch-out}
randtests::runs.test(
  x = puntuacion, alternative = "two.sided",
  threshold = median(puntuacion), pvalue = "exact",
  plot = FALSE
)
```

```{.bg-warning}
#> 
#> 	Runs Test
#> 
#> data:  puntuacion
#> statistic = -1.2523, runs = 10, n1 = 12, n2 = 12, n = 24,
#> p-value = 0.3009
#> alternative hypothesis: nonrandomness
```
<br/>

La función runs.test` del paquete `randtests` también realiza el gráfico mostrado en la figura \@ref(fig:rachas9), pero menos elegante que este. Si se quiere ver este gráfico se cambia el parámetro `plot` a `TRUE`.

La función `runs.test` del paquete `snpar` también ejecuta la prueba, como se muestra en el siguiente trozo de código.


```{.r .watch-out}
snpar::runs.test(
  x = puntuacion, exact = T,
  alternative = "two.sided"
)
```

```{.bg-warning}
#> 
#> 	Exact runs test
#> 
#> data:  puntuacion
#> Runs = 10, p-value = 0.3009
#> alternative hypothesis: two.sided
```
<br/>

**Ejemplo 10:** Un investigador estaba interesado en averiguar si la disposición de hombres y mujeres en una fila enfrente de la taquilla de un teatro era un arreglo aleatorio. Los datos se obtuvieron simplemente anotando el sexo de cada una de las 50 personas al aproximarse a la taquilla.
$$
\begin{array}{ccccccccccccc}
\hline
M & F & M & F & M & M & M & F & F & M & F & M & F \\
M & F & M & M & M & M & F & M & F & M & F & M & M \\
F & F & F & M & F & M & F & M & F & M & M & F &   \\
M & M & F & M & M & M & M & F & M & F & M & M &   \\
\hline
\end{array}
$$
Los datos fueron tomados de Siegel (2012, pág. 86)



```{.r .watch-out}
cola <- c(
  "M", "F", "M", "F", "M", "M", "M", "F", "F", "M", "F",
  "M", "F", "M", "F", "M", "M", "M", "M", "F", "M", "F",
  "M", "F", "M", "M", "F", "F", "F", "M", "F", "M", "F",
  "M", "F", "M", "M", "F", "M", "M", "F", "M", "M", "M",
  "M", "F", "M", "F", "M", "M"
)
n1 <- min(table(cola))
n2 <- max(table(cola))
n <- n1 + n2
ind <- fct_infreq(cola) %>%
  fct_rev() %>%
  levels(.)
n1 <- length(cola[cola == ind[1]])
n2 <- length(cola[cola == ind[2]])
rachas <- rle(cola)
rachas10 <- as.data.frame.list(rachas) %>%
  dplyr::rename(
    lonjitud = lengths,
    signo = values
  )
r1 <- rachas10 %>%
  dplyr::filter(
    signo == ind[1]
  ) %>%
  nrow(.)
r2 <- rachas10 %>%
  dplyr::filter(
    signo == ind[2]
  ) %>%
  nrow(.)
r <- r1 + r2
mu_R <- 2 * n1 * n2 / n + 1
var_R <- 2 * n1 * n2 * (2 * n1 * n2 - n) / (n^2 * (n - 1))
z <- (r - mu_R) / sqrt(var_R)
z.corr <- (r - mu_R - 0.5) / sqrt(var_R)
p.valor <- 2 * pruns(q = r - 1, n1 = n1, n2 = n2, lower.tail = FALSE)
p.valor.aprox <- 2 * pnorm(z, lower.tail = FALSE)
p.valor.aprox.cor <- 2 * pnorm(z.corr, lower.tail = FALSE)
paste("n =", n, "n1 =", n1, "n2 =", n2, "r1 =", r1, "r2 =", r2)
paste("La media del estadístico R =", mu_R)
paste("La varianza del estadístico R =", var_R)
paste("El valor del estadístico R =", r)
paste("El valor del estadístico Z =", z)
paste("El valor del estadístico Z (corregido) =", z.corr)
paste("El p.valor =", round(x = p.valor, digits = 6))
paste("El p.valor.aprox =", round(x = p.valor.aprox, digits = 6))
paste("El p.valor.aprox con corrección =", round(x = p.valor.aprox.cor, digits = 6))
```

```{.bg-warning}
#> [1] "n = 50 n1 = 20 n2 = 30 r1 = 17 r2 = 18"
#> [1] "La media del estadístico R = 25"
#> [1] "La varianza del estadístico R = 11.265306122449"
#> [1] "El valor del estadístico R = 35"
#> [1] "El valor del estadístico Z = 2.97939785765562"
#> [1] "El valor del estadístico Z (corregido) = 2.83042796477284"
#> [1] "El p.valor = 0.003748"
#> [1] "El p.valor.aprox = 0.002888"
#> [1] "El p.valor.aprox con corrección = 0.004649"
```
<br/>

Como se observa en la salida anterior el  $p_{valor} = 0.0037481$, lo que indica que la disposición de hombres y mujeres en una fila enfrente de la taquilla del teatro no es aleatorio. Note que $R = 35 > \mu_R = 25$, por lo que el $p_{valor}=2P\left(R \geq r \right)$.

La figura \@ref(fig:datos10) muestra la gráfica de las rachas de hombres y mujeres en la taquilla. Y esta muestra que las longitudes de las rachas tienen un comportamiento aleatorio,  lo cual contrasta con la conclusión anterior.  


```{.r .watch-out}
datos10 <- tibble(
  personas = 1:length(cola),
  cola = cola,
  codigo = ifelse(cola == "M", 1, 0)
)
ggplot(datos10, aes(x = personas, y = codigo)) +
  geom_point(aes(colour = as.factor(cola)), size = 2) +
  geom_vline(
    xintercept = rachas10 %>%
      dplyr::select(lonjitud) %>%
      dplyr::slice(1:nrow(.) - 1) %>%
      dplyr::pull(lonjitud) %>%
      cumsum(.) + 0.5,
    color = "steelblue",
    linetype = "dashed",
    size = 1
  ) +
  geom_hline(
    yintercept = 0.5,
    color = "red",
    linetype = "solid",
    size = 1
  ) +
  labs(
    x = "Niños",
    y = "Puntuación"
  ) +
  theme_minimal() +
  scale_colour_brewer(palette = "Set1") +
  theme(
    panel.grid.major = element_line(
      colour = "lightsteelblue1",
      size = 0.25, linetype = "twodash"
    ),
    axis.title = element_text(face = "bold.italic"),
    panel.background = element_rect(fill = "white", linetype = "solid"),
    plot.background = element_rect(fill = "antiquewhite", colour = NA)
  ) +
  theme(
    axis.line = element_line(
      colour = NA,
      linetype = "solid"
    ), axis.title = element_text(size = 10),
    axis.text.x = element_text(size = 9),
    axis.text.y = element_text(size = 9),
    plot.title = element_text(size = 12),
    plot.background = element_rect(fill = "antiquewhite1"),
    legend.position = "NULL"
  )
```

<div class="figure">
<img src="_main_files/figure-html/datos10-1.png" alt="Rachas para las puntuaciones de agresión de acuerdo al orden de ocurrencia" width="672" />
<p class="caption">(\#fig:datos10)Rachas para las puntuaciones de agresión de acuerdo al orden de ocurrencia</p>
</div>

Los resultados anteriores se pueden contrastar aplicando la función `runs.test` del paquete `randtests`. Note que en el trozo de código que se muestra abajo el parámetro `pvalue` se ha establecido como `"exact"` para generar el $p_{valor}$ exacto. Si este se establece como `"norma"l`, el $p_{valor}$ que muestra la salida es el aproximado sin corrección por continuidad. Intente correr este script cambiando la configuración de este parámetro y observe el $p_{valor}$.


```{.r .watch-out}
randtests::runs.test(
  x = datos10$codigo, alternative = "two.sided",
  threshold = 0.5, pvalue = "exact",
  plot = FALSE
)
```

```{.bg-warning}
#> 
#> 	Runs Test
#> 
#> data:  datos10$codigo
#> statistic = 2.9794, runs = 35, n1 = 30, n2 = 20, n = 50,
#> p-value = 0.003748
#> alternative hypothesis: nonrandomness
```
<br/>

Con el siguiente trozo de código se ha ejecutado la prueba con la función `runs.test` del paquete `snpar`. Observe que el parámetro `exact = FALSE`. Compare este $p_{valor}$ con los anteriores.


```{.r .watch-out}
snpar::runs.test(
  x = datos10$codigo, exact = FALSE,
  alternative = "two.sided"
)
```

```{.bg-warning}
#> 
#> 	Approximate runs rest
#> 
#> data:  datos10$codigo
#> Runs = 35, p-value = 0.002888
#> alternative hypothesis: two.sided
```
<br/>


## Información de Sesión {#sesion}


```{.r .watch-out}
as_tibble(devtools::session_info()$packages) %>%
  dplyr::select(
    package, loadedversion, source
  ) %>%
  dplyr::filter(
    package %in% packages
  ) %>%
  DT::datatable(
    rownames = FALSE,
    colnames = c("Paquete", "Versión", "Fuente"),
    caption = "Información de sesión",
    filter = "top",
    selection = "multiple",
    class = "cell-border stripe"
  )
```

```{=html}
<div id="htmlwidget-4d858f1b256aa74e4d48" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-4d858f1b256aa74e4d48">{"x":{"filter":"top","vertical":false,"filterHTML":"<tr>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n  <\/td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n  <\/td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n  <\/td>\n<\/tr>","caption":"<caption>Información de sesión<\/caption>","data":[["bookdown","bookdownplus","BSDA","devtools","DT","Hmisc","hrbrthemes","htmltools","htmlwidgets","kableExtra","knitcitations","kolmim","magrittr","MASS","NSM3","plotly","randtests","reshape2","rmarkdown","snpar","stringr","tidyverse","utf8"],["0.24","1.5.8","1.2.0","2.4.2","0.19","4.5-0","0.8.0","0.5.2","1.5.4","1.3.4","1.0.12","1.0","2.0.1","7.3-54","1.16","4.10.0","1.0","1.4.4","2.11","1.0","1.4.0","1.3.1","1.2.1"],["CRAN (R 4.0.5)","CRAN (R 4.0.5)","CRAN (R 4.0.5)","CRAN (R 4.0.5)","CRAN (R 4.0.5)","CRAN (R 4.0.4)","CRAN (R 4.0.4)","CRAN (R 4.0.5)","CRAN (R 4.0.5)","CRAN (R 4.0.4)","CRAN (R 4.0.5)","CRAN (R 4.0.3)","CRAN (R 4.0.3)","CRAN (R 4.0.5)","CRAN (R 4.0.5)","CRAN (R 4.0.5)","CRAN (R 4.0.3)","CRAN (R 4.0.3)","CRAN (R 4.0.5)","CRAN (R 4.0.3)","CRAN (R 4.0.3)","CRAN (R 4.0.5)","CRAN (R 4.0.3)"]],"container":"<table class=\"cell-border stripe\">\n  <thead>\n    <tr>\n      <th>Paquete<\/th>\n      <th>Versión<\/th>\n      <th>Fuente<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"order":[],"autoWidth":false,"orderClasses":false,"orderCellsTop":true}},"evals":[],"jsHooks":[]}</script>
```





# Bibliografía {-}

[1] G. Aden-Buie. _cleanrmd: Clean Class-Less R Markdown
HTML Documents_. R package version 0.0.7. 2021. <URL:
https://github.com/gadenbuie/cleanrmd>.

[2] J. Allaire, Y. Xie, J. McPherson, et al. _rmarkdown:
Dynamic Documents for R_. R package version 2.11. 2021.
<URL: https://CRAN.R-project.org/package=rmarkdown>.

[3] A. T. Arnholt and B. Evans. _BSDA: Basic Statistics
and Data Analysis_. R package version 1.2.0. 2017. <URL:
https://CRAN.R-project.org/package=BSDA>.

[4] S. M. Bache and H. Wickham. _magrittr: A Forward-Pipe
Operator for R_. R package version 2.0.1. 2020. <URL:
https://CRAN.R-project.org/package=magrittr>.

[5] C. Boettiger. _knitcitations: Citations for Knitr
Markdown Files_. R package version 1.0.12. 2021. <URL:
https://github.com/cboettig/knitcitations>.

[6] F. Caeiro and A. Mateus. _randtests: Testing
randomness in R_. R package version 1.0. 2014. <URL:
https://CRAN.R-project.org/package=randtests>.

[7] L. Carvalho. "An Improved Evaluation of Kolmogorov's
Distribution". In: _Journal of Statistical Software_ 65.3
(2015), pp. 1-7. <URL: http://www.jstatsoft.org/v65/c03/>.

[8] L. Carvalho. _kolmim: An Improved Evaluation of
Kolmogorov's Distribution_. R package version 1.0. 2015.
<URL: https://CRAN.R-project.org/package=kolmim>.

[9] S. Chasalow. _combinat: combinatorics utilities_. R
package version 0.0-8. 2012. <URL:
https://CRAN.R-project.org/package=combinat>.

[10] J. Cheng, C. Sievert, B. Schloerke, et al.
_htmltools: Tools for HTML_. R package version 0.5.2.
2021. <URL: https://github.com/rstudio/htmltools>.

[11] R. K. S. Hankin. "Additive integer partitions in R".
In: _Journal of Statistical Software, Code Snippets_ 16 (1
may. 2006).

[12] R. K. S. Hankin. _partitions: Additive Partitions of
Integers_. R package version 1.10-2. 2021. <URL:
https://github.com/RobinHankin/partitions>.

[13] F. E. Harrell Jr. _Hmisc: Harrell Miscellaneous_. R
package version 4.5-0. 2021. <URL:
https://CRAN.R-project.org/package=Hmisc>.

[14] L. Henry and H. Wickham. _purrr: Functional
Programming Tools_. R package version 0.3.4. 2020. <URL:
https://CRAN.R-project.org/package=purrr>.

[15] K. MÃ¼ller and H. Wickham. _tibble: Simple Data
Frames_. R package version 3.1.5. 2021. <URL:
https://CRAN.R-project.org/package=tibble>.

[16] P. O. Perry. _utf8: Unicode Text Processing_. R
package version 1.2.1. 2021. <URL:
https://CRAN.R-project.org/package=utf8>.

[17] D. Qiu. _snpar: Supplementary Non-parametric
Statistics Methods_. R package version 1.0. 2014. <URL:
https://CRAN.R-project.org/package=snpar>.

[18] R Core Team. _R: A Language and Environment for
Statistical Computing_. R Foundation for Statistical
Computing. Vienna, Austria, 2020. <URL:
https://www.R-project.org/>.

[19] B. Ripley. _MASS: Support Functions and Datasets for
Venables and Ripley's MASS_. R package version 7.3-54.
2021. <URL: http://www.stats.ox.ac.uk/pub/MASS4/>.

[20] B. Rudis. _hrbrthemes: Additional Themes, Theme
Components and Utilities for ggplot2_. R package version
0.8.0. 2020. <URL: http://github.com/hrbrmstr/hrbrthemes>.

[21] D. Sarkar. _Lattice: Multivariate Data Visualization
with R_. ISBN 978-0-387-75968-5. New York: Springer, 2008.
<URL: http://lmdvr.r-forge.r-project.org>.

[22] D. Sarkar. _lattice: Trellis Graphics for R_. R
package version 0.20-44. 2021. <URL:
http://lattice.r-forge.r-project.org/>.

[23] G. Schneider, E. Chicken, and R. Becvarik. _NSM3:
Functions and Datasets to Accompany Hollander, Wolfe, and
Chicken - Nonparametric Statistical Methods, Third
Edition_. R package version 1.16. 2021. <URL:
https://CRAN.R-project.org/package=NSM3>.

[24] C. Sievert. _Interactive Web-Based Data Visualization
with R, plotly, and shiny_. Chapman and Hall/CRC, 2020.
ISBN: 9781138331457. <URL: https://plotly-r.com>.

[25] C. Sievert, C. Parmer, T. Hocking, et al. _plotly:
Create Interactive Web Graphics via plotly.js_. R package
version 4.10.0. 2021. <URL:
https://CRAN.R-project.org/package=plotly>.

[26] Terry M. Therneau and Patricia M. Grambsch. _Modeling
Survival Data: Extending the Cox Model_. New York:
Springer, 2000. ISBN: 0-387-98784-3.

[27] T. M. Therneau. _survival: Survival Analysis_. R
package version 3.2-11. 2021. <URL:
https://github.com/therneau/survival>.

[28] R. Vaidyanathan, Y. Xie, J. Allaire, et al.
_htmlwidgets: HTML Widgets for R_. R package version
1.5.4. 2021. <URL:
https://github.com/ramnathv/htmlwidgets>.

[29] W. N. Venables and B. D. Ripley. _Modern Applied
Statistics with S_. Fourth. ISBN 0-387-95457-0. New York:
Springer, 2002. <URL:
https://www.stats.ox.ac.uk/pub/MASS4/>.

[30] H. Wickham. _forcats: Tools for Working with
Categorical Variables (Factors)_. R package version 0.5.1.
2021. <URL: https://CRAN.R-project.org/package=forcats>.

[31] H. Wickham. _ggplot2: Elegant Graphics for Data
Analysis_. Springer-Verlag New York, 2016. ISBN:
978-3-319-24277-4. <URL: https://ggplot2.tidyverse.org>.

[32] H. Wickham. _reshape2: Flexibly Reshape Data: A
Reboot of the Reshape Package_. R package version 1.4.4.
2020. <URL: https://github.com/hadley/reshape>.

[33] H. Wickham. "Reshaping Data with the reshape
Package". In: _Journal of Statistical Software_ 21.12
(2007), pp. 1-20. <URL:
http://www.jstatsoft.org/v21/i12/>.

[34] H. Wickham. _stringr: Simple, Consistent Wrappers for
Common String Operations_. R package version 1.4.0. 2019.
<URL: https://CRAN.R-project.org/package=stringr>.

[35] H. Wickham. _tidyr: Tidy Messy Data_. R package
version 1.1.4. 2021. <URL:
https://CRAN.R-project.org/package=tidyr>.

[36] H. Wickham. _tidyverse: Easily Install and Load the
Tidyverse_. R package version 1.3.1. 2021. <URL:
https://CRAN.R-project.org/package=tidyverse>.

[37] H. Wickham, M. Averick, J. Bryan, et al. "Welcome to
the tidyverse". In: _Journal of Open Source Software_ 4.43
(2019), p. 1686. DOI: 10.21105/joss.01686.

[38] H. Wickham, J. Bryan, and M. Barrett. _usethis:
Automate Package and Project Setup_. R package version
2.1.3. 2021. <URL:
https://CRAN.R-project.org/package=usethis>.

[39] H. Wickham, W. Chang, L. Henry, et al. _ggplot2:
Create Elegant Data Visualisations Using the Grammar of
Graphics_. R package version 3.3.5. 2021. <URL:
https://CRAN.R-project.org/package=ggplot2>.

[40] H. Wickham, R. FranÃ§ois, L. Henry, et al. _dplyr: A
Grammar of Data Manipulation_. R package version 1.0.6.
2021. <URL: https://CRAN.R-project.org/package=dplyr>.

[41] H. Wickham and J. Hester. _readr: Read Rectangular
Text Data_. R package version 1.4.0. 2020. <URL:
https://CRAN.R-project.org/package=readr>.

[42] H. Wickham, J. Hester, and W. Chang. _devtools: Tools
to Make Developing R Packages Easier_. R package version
2.4.2. 2021. <URL:
https://CRAN.R-project.org/package=devtools>.

[43] Y. Xie. _bookdown: Authoring Books and Technical
Documents with R Markdown_. ISBN 978-1138700109. Boca
Raton, Florida: Chapman and Hall/CRC, 2016. <URL:
https://bookdown.org/yihui/bookdown>.

[44] Y. Xie. _bookdown: Authoring Books and Technical
Documents with R Markdown_. R package version 0.24. 2021.
<URL: https://CRAN.R-project.org/package=bookdown>.

[45] Y. Xie, J. Allaire, and G. Grolemund. _R Markdown:
The Definitive Guide_. ISBN 9781138359338. Boca Raton,
Florida: Chapman and Hall/CRC, 2018. <URL:
https://bookdown.org/yihui/rmarkdown>.

[46] Y. Xie, J. Cheng, and X. Tan. _DT: A Wrapper of the
JavaScript Library DataTables_. R package version 0.19.
2021. <URL: https://github.com/rstudio/DT>.

[47] Y. Xie, C. Dervieux, and E. Riederer. _R Markdown
Cookbook_. ISBN 9780367563837. Boca Raton, Florida:
Chapman and Hall/CRC, 2020. <URL:
https://bookdown.org/yihui/rmarkdown-cookbook>.

[48] A. Zeileis and Y. Croissant. "Extended Model Formulas
in R: Multiple Parts and Multiple Responses". In: _Journal
of Statistical Software_ 34.1 (2010), pp. 1-13. DOI:
10.18637/jss.v034.i01.

[49] A. Zeileis and Y. Croissant. _Formula: Extended Model
Formulas_. R package version 1.2-4. 2020. <URL:
https://CRAN.R-project.org/package=Formula>.

[50] P. Zhao. _bookdownplus: Generate Assorted Books and
Documents with R bookdown Package_. R package version
1.5.8. 2020. <URL:
https://github.com/pzhaonet/bookdownplus>.

[51] H. Zhu. _kableExtra: Construct Complex Table with
kable and Pipe Syntax_. R package version 1.3.4. 2021.
<URL: https://CRAN.R-project.org/package=kableExtra>.

<!--chapter:end:index.Rmd-->

