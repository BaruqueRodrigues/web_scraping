## O que é webscraping?

Web scraping, também conhecido como extração de dados da web, é o processo de coletar automaticamente informações de sites da internet, sejam dados estruturados, em formatos de tabelas, ou em objetos tabulares, ou dados não estruturado. Feito por meio de programas de software que acessam as páginas web, analisam seu conteúdo e extraem os dados relevantes de acordo com os critérios estabelecidos.

#### Por que fazer webscraping?

Por que ele leva muito menos tempo que um humano, ou grupo de humanos levaria para a coletar a informação, por que ele é transparente e pode ter seus critérios avaliados, e por que ele evita que erros sejam cometidos.

Os dados extraídos podem incluir texto, imagens, links, tabelas e outros elementos presentes nas páginas web. O web scraping é frequentemente utilizado para diversas finalidades, como:

1.  **Mineração de dados**: Extrair informações de sites para análise e obtenção de insights.

2.  **Comparação de preços**: Monitorar os preços de produtos em diferentes sites de comércio eletrônico.

3.  **Acompanhamento de notícias**: Coletar notícias e artigos de diferentes fontes.

4.  **Monitoramento de redes sociais**: Capturar informações de perfis e postagens em plataformas como Twitter, Facebook, etc.

5.  **Geração de leads**: Coletar informações de contato de potenciais clientes.

6.  **Pesquisa de mercado**: Obter dados sobre concorrentes, produtos e tendências do mercado.

7.  **Automatização de tarefas**: Automatizar processos que envolvem a coleta de informações na web.

#### Quais as abordagens de extração de dados nós veremos?

1.  Extraindo Dados de Paginas Estáticas

    Páginas estáticas são páginas que possuem conteúdo que não muda dinamicamente com o tempo ou em resposta a interações do usuário. Páginas estáticas são aquelas cujo conteúdo é o mesmo sempre que são acessadas, a menos que sejam manualmente atualizadas pelo proprietário do site.

    Neste contexto, "estáticas" se refere ao fato de que o conteúdo da página não é gerado dinamicamente a partir de uma fonte de dados em tempo real, como um banco de dados ou um serviço que fornece informações atualizadas constantemente.

    Exemplos: [uma página do wikipedia](https://pt.wikipedia.org/wiki/Lista_de_pa%C3%ADses_por_popula%C3%A7%C3%A3o), o site [chance de gol](https://chancedegol.com.br/br22.htm), os dados da [amazon](https://www.amazon.com.br/s?k=anilhas+olimpica&dc&__mk_pt_BR=%C3%85M%C3%85%C5%BD%C3%95%C3%91&crid=3G7N1VMRIZIDT&sprefix=anilhas+olimipica%2Caps%2C166&ref=a9_sc_1).

2.  Extraindo Dados de PDF's

    Em alguns casos nossos dados alvo são disponibilizados através de uma tabela em PDF, ou em imagem, todavia por mais que os dados estejam disponibilizados, é muito complicado transpô-los para um ambiente computacional onde podemos analisar os dados, para resolver o problema usamos técnicas de OCR (Optical Character Recognition) que é uma técnica que envolve a extração de dados de imagens ou documentos digitalizados. O OCR é um processo que converte texto contido em uma imagem em texto editável, tornando possível a análise e extração desses dados.

    Essa abordagem é útil quando os dados que se deseja extrair estão presentes em imagens ou documentos que não podem ser facilmente acessados por técnicas tradicionais de scraping, que normalmente trabalham com texto e código HTML.

    Um ótimo exemplo são os dados do Índice de Sustentabilidade da Limpeza Urbana, que têm seus dados disponibilizados em formatos de tabela ao fim de cada [*relatório*](https://selur.org.br/wp-content/uploads/2021/05/ISLU-2020-a.pdf).

3.  Extraindo Dados usando o Web Drivers

    Em alguns casos nossos dados são disponibilizados em formatos estáticos, entretanto precisam de multiplas interações, ou uma interação complexa entre a página e o usuário para disponibilizar nossos dados. Nesse caso usamos webdrivers que desempenham a automação em um navegador web real para interagir com páginas da web, permitindo assim a extração de dados que podem ser mais difíceis de obter apenas com técnicas de scraping tradicionais.

    Uma vantagem importante do uso de webdrivers é a capacidade de lidar com páginas que dependem fortemente de JavaScript e têm conteúdo que é gerado dinamicamente após o carregamento inicial.

4.  Extraindo dados que já estão disponíveis para download

    Existe também a possibilidade de nossos dados serem disponibilizados para download, todavia baixar um grande volume de dados levaria muito tempo, já que toda solicitação deveria ser feita manualmente, pra esse tipo de problema a extração pode ser utilizada para automatizar o processo de download de arquivos de diferentes maneiras, dependendo do contexto e dos recursos disponíveis.

    Um exemplo claro são os dados do portal da [transparência](https://portaldatransparencia.gov.br/download-de-dados/despesas-execucao), que são disponibilizados a cada mês, todavia é necessário selecionar o download de mês a mês, podemos utilizar essa abordagem para coletar esses dados.

5.  Extraindo Dados via API's

    Em alguns asos nossos dados já estão estruturados e disponibilizados e são disponibilizados via uma API que é mantida e fornecida por uma plataforma. Ao contrário do scraping tradicional, que envolve a análise de HTML, a conexão com APIs fornece um método estruturado e direto para obter dados, todavia tem uma heurística própria, que a depender da familiaridade do usuário com a técnica pode tornar a raspagem via api muito rápida, eficiente e robusta.

    Um exemplo são os dados da api da [câmara dos deputados](https://dadosabertos.camara.leg.br/api/v2/deputados/220552/discursos?idLegislatura=57)

6.  Raspagem de Dados em Texto

Existe a possibilidade de nossos dados serem disponibilizados em formato de texto, todavia ainda que os dados possam ser inseridos no ambiente computacional, eles não podem ser analisados pois não estão estruturados de formato tabular, nesse caso podemos extrair os dados dos textos onde nosso objetivo é extrair informações específicas de documentos ou fontes que são principalmente baseadas em texto. Esses dados podem estar em diversos formatos, como: Documentos de Texto, emails, redes sociais, decisões judiciais e afins.
