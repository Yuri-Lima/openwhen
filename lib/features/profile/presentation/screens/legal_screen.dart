import 'package:flutter/material.dart';
import '../../../../shared/widgets/owl_logo.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/app_theme.dart';

enum LegalType { terms, privacy, about, help }

class LegalScreen extends StatelessWidget {
  final LegalType type;
  const LegalScreen({super.key, required this.type});

  String get _title {
    switch (type) {
      case LegalType.terms: return 'Termos de Uso';
      case LegalType.privacy: return 'Política de Privacidade';
      case LegalType.about: return 'Sobre o OpenWhen';
      case LegalType.help: return 'Ajuda e Suporte';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1A1714), Color(0xFF2C1810), Color(0xFF1A1714)],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.arrow_back, size: 18, color: Colors.white.withOpacity(0.6)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(_title,
                        style: GoogleFonts.dmSerifDisplay(fontSize: 20, color: AppColors.white, fontStyle: FontStyle.italic)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (type) {
      case LegalType.terms: return _buildTerms();
      case LegalType.privacy: return _buildPrivacy();
      case LegalType.about: return _buildAbout();
      case LegalType.help: return _buildHelp();
    }
  }

  Widget _buildTerms() {
    return _buildLegalContent(
      lastUpdate: '22 de março de 2026',
      intro: 'Estes Termos de Uso ("Termos") regulam o acesso e a utilização do aplicativo OpenWhen ("Plataforma"), desenvolvido e operado pela OpenWhen Tecnologia Ltda. ("Empresa"), inscrita no CNPJ sob o nº [XX.XXX.XXX/0001-XX], com sede no Brasil. A utilização da Plataforma implica a aceitação integral e irrestrita destes Termos, nos termos do art. 8º da Lei nº 12.965/2014 (Marco Civil da Internet) e da Lei nº 13.709/2018 (Lei Geral de Proteção de Dados — LGPD).',
      sections: [
        _Section('1. DO OBJETO E NATUREZA DO SERVIÇO',
          'O OpenWhen é uma plataforma digital de comunicação temporal que permite aos usuários criar, enviar, receber e armazenar mensagens eletrônicas ("Cartas") programadas para abertura em data futura determinada pelo remetente. O serviço possui natureza de intermediação digital de comunicação privada e, quando autorizado pelo usuário, de publicação em ambiente de rede social ("Feed Público"). A Empresa atua como provedora de aplicação, nos termos do art. 5º, inciso VII, do Marco Civil da Internet.'),
        _Section('2. DOS REQUISITOS PARA UTILIZAÇÃO',
          'Para utilizar a Plataforma, o usuário deverá: (i) ter capacidade civil plena, nos termos do art. 3º do Código Civil Brasileiro (Lei nº 10.406/2002), ou ser assistido por responsável legal quando menor de 16 anos; (ii) fornecer dados verídicos no cadastro, sob pena de cancelamento imediato da conta, nos termos do art. 7º, inciso VI, do Marco Civil da Internet; (iii) manter a confidencialidade de suas credenciais de acesso, sendo responsável por todas as atividades realizadas em sua conta.'),
        _Section('3. DAS OBRIGAÇÕES E RESPONSABILIDADES DO USUÁRIO',
          'O usuário se compromete a utilizar a Plataforma em conformidade com a legislação vigente, especialmente: (i) a Lei nº 12.965/2014 (Marco Civil da Internet); (ii) a Lei nº 13.709/2018 (LGPD); (iii) o Código Penal Brasileiro no que tange a crimes contra a honra (arts. 138 a 140); (iv) a Lei nº 7.716/1989 (Lei de Crimes de Preconceito); e (v) o Estatuto da Criança e do Adolescente (ECA — Lei nº 8.069/1990). É expressamente vedado ao usuário publicar conteúdo que: (a) seja difamatório, calunioso ou injurioso; (b) incite violência, ódio ou discriminação de qualquer natureza; (c) viole direitos de propriedade intelectual de terceiros; (d) constitua assédio, cyberbullying ou perseguição; (e) envolva pornografia infantil ou conteúdo sexual envolvendo menores de idade.'),
        _Section('4. DA RESPONSABILIDADE CIVIL DA EMPRESA',
          'A Empresa, na qualidade de provedora de aplicação, não se responsabiliza pelo conteúdo gerado pelos usuários ("UGC — User Generated Content"), nos termos do art. 19 do Marco Civil da Internet. A responsabilidade civil da Empresa somente será configurada mediante descumprimento de ordem judicial específica determinando a remoção de conteúdo. A Empresa adota mecanismos de moderação e denúncia, sem que isso implique assunção de responsabilidade editorial sobre o conteúdo dos usuários.'),
        _Section('5. DA PROPRIEDADE INTELECTUAL',
          'O usuário é e permanece titular dos direitos autorais sobre o conteúdo que cria na Plataforma, nos termos da Lei nº 9.610/1998 (Lei de Direitos Autorais). Ao publicar conteúdo no Feed Público, o usuário concede à Empresa licença não exclusiva, irrevogável, gratuita e mundial para reproduzir, distribuir e exibir tal conteúdo exclusivamente no âmbito da Plataforma, podendo revogar tal licença mediante a exclusão do conteúdo ou encerramento da conta. A marca, logotipo, design e código-fonte do OpenWhen são de titularidade exclusiva da Empresa e protegidos pela Lei nº 9.279/1996 (Lei da Propriedade Industrial).'),
        _Section('6. DA VIGÊNCIA E RESCISÃO',
          'O presente contrato vigorará por prazo indeterminado a partir do cadastro do usuário. O usuário poderá rescindir o contrato a qualquer momento mediante exclusão de sua conta nas configurações da Plataforma, nos termos do art. 7º, inciso IX, do Marco Civil da Internet. A Empresa reserva-se o direito de suspender ou encerrar contas que violem estes Termos, sem prejuízo das demais medidas legais cabíveis.'),
        _Section('7. DAS DISPOSIÇÕES GERAIS',
          'Estes Termos são regidos pelas leis da República Federativa do Brasil. Fica eleito o foro da comarca de São Paulo/SP para dirimir quaisquer controvérsias decorrentes deste instrumento, com renúncia expressa a qualquer outro foro, por mais privilegiado que seja. A nulidade de qualquer cláusula não afeta a validade das demais. Dúvidas e notificações devem ser encaminhadas para: juridico@openwhen.app. Última atualização: 22 de março de 2026.'),
      ],
    );
  }

  Widget _buildPrivacy() {
    return _buildLegalContent(
      lastUpdate: '22 de março de 2026',
      intro: 'Esta Política de Privacidade ("Política") descreve como a OpenWhen Tecnologia Ltda. ("Empresa", "nós") coleta, trata, armazena e compartilha os dados pessoais dos usuários da Plataforma OpenWhen, em conformidade com a Lei nº 13.709/2018 (Lei Geral de Proteção de Dados — LGPD), o Regulamento Geral de Proteção de Dados da União Europeia (GDPR — Regulamento EU 2016/679), a Lei nº 12.965/2014 (Marco Civil da Internet) e demais normas aplicáveis. A Empresa atua como Controladora de Dados, nos termos do art. 5º, inciso VI, da LGPD.',
      sections: [
        _Section('1. DOS DADOS PESSOAIS COLETADOS',
          'A Empresa coleta as seguintes categorias de dados pessoais: (i) Dados de cadastro: nome completo, endereço de e-mail, nome de usuário e foto de perfil; (ii) Dados de uso: interações na Plataforma, cartas criadas, enviadas e recebidas, curtidas e comentários; (iii) Dados técnicos: endereço IP, identificador do dispositivo, sistema operacional e logs de acesso, nos termos do art. 15 do Marco Civil da Internet; (iv) Dados de localização: país de origem, coletado de forma não precisa e apenas para personalização do serviço. Não coletamos dados pessoais sensíveis, conforme definição do art. 5º, inciso II, da LGPD, salvo mediante consentimento expresso.'),
        _Section('2. DAS BASES LEGAIS PARA O TRATAMENTO',
          'O tratamento dos dados pessoais dos usuários fundamenta-se nas seguintes hipóteses legais previstas no art. 7º da LGPD: (i) Consentimento do titular, nos termos do art. 7º, inciso I, manifestado no momento do cadastro; (ii) Execução de contrato, nos termos do art. 7º, inciso V, para prestação dos serviços contratados; (iii) Legítimo interesse da Empresa, nos termos do art. 7º, inciso IX, para melhoria da Plataforma, prevenção a fraudes e segurança do serviço; (iv) Cumprimento de obrigação legal ou regulatória, nos termos do art. 7º, inciso II.'),
        _Section('3. DA FINALIDADE DO TRATAMENTO',
          'Os dados pessoais coletados são tratados para as seguintes finalidades: (i) Prestação dos serviços da Plataforma; (ii) Personalização da experiência do usuário; (iii) Envio de notificações relacionadas ao serviço; (iv) Melhoria contínua da Plataforma; (v) Prevenção a fraudes e garantia de segurança; (vi) Cumprimento de obrigações legais e regulatórias; (vii) Exercício regular de direitos em processos judiciais, administrativos ou arbitrais. Os dados não são utilizados para publicidade de terceiros.'),
        _Section('4. DO COMPARTILHAMENTO DE DADOS',
          'A Empresa não vende, aluga ou cede dados pessoais a terceiros para fins comerciais. O compartilhamento de dados ocorre exclusivamente nas seguintes hipóteses: (i) Com prestadores de serviço essenciais à operação da Plataforma (Firebase/Google Cloud), na condição de Operadores de Dados, mediante contrato que garanta nível adequado de proteção; (ii) Com autoridades públicas, mediante ordem judicial ou requisição legal fundamentada; (iii) Com adquirente em caso de fusão, aquisição ou reestruturação societária, garantida a continuidade desta Política.'),
        _Section('5. DOS DIREITOS DO TITULAR (LGPD — Art. 18)',
          'Nos termos do art. 18 da LGPD, o usuário titular dos dados tem direito a: (i) Confirmação da existência de tratamento; (ii) Acesso aos dados; (iii) Correção de dados incompletos, inexatos ou desatualizados; (iv) Anonimização, bloqueio ou eliminação de dados desnecessários; (v) Portabilidade dos dados a outro fornecedor, mediante requisição expressa; (vi) Eliminação dos dados tratados com base no consentimento; (vii) Informação sobre compartilhamento com terceiros; (viii) Revogação do consentimento. Para exercer seus direitos, acesse Configurações > Dados e Privacidade ou contate: privacidade@openwhen.app. O prazo de resposta é de até 15 dias úteis.'),
        _Section('6. DA SEGURANÇA E RETENÇÃO DOS DADOS',
          'A Empresa adota medidas técnicas e organizacionais adequadas para proteger os dados pessoais contra acesso não autorizado, destruição, perda ou alteração, incluindo: criptografia em trânsito (TLS 1.3) e em repouso, controle de acesso baseado em funções e monitoramento contínuo de segurança. Os dados são retidos pelo período necessário às finalidades do tratamento e eliminados ao término da relação contratual, salvo obrigação legal de retenção. Em caso de incidente de segurança, o titular será notificado nos termos do art. 48 da LGPD.'),
        _Section('7. DAS TRANSFERÊNCIAS INTERNACIONAIS',
          'Os dados pessoais dos usuários podem ser transferidos para servidores localizados fora do Brasil (Google Cloud Platform), em conformidade com o art. 33 da LGPD, garantindo nível de proteção adequado mediante cláusulas contratuais padrão aprovadas pela Autoridade Nacional de Proteção de Dados (ANPD).'),
        _Section('8. DO ENCARREGADO DE PROTEÇÃO DE DADOS (DPO)',
          'Nos termos do art. 41 da LGPD, o Encarregado de Proteção de Dados (DPO) da Empresa pode ser contatado em: dpo@openwhen.app. Última atualização: 22 de março de 2026.'),
      ],
    );
  }

  Widget _buildAbout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Column(
            children: [
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: AppColors.accent.withOpacity(0.3), blurRadius: 20)],
                ),
                child: Center(
                  child: const OwlLogo(size: 64),
                ),
              ),
              const SizedBox(height: 16),
              Text('OpenWhen', style: GoogleFonts.dmSerifDisplay(fontSize: 28, color: AppColors.ink, fontStyle: FontStyle.italic)),
              const SizedBox(height: 4),
              Text('Escreva hoje. Sinta amanhã.',
                style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.inkSoft, fontStyle: FontStyle.italic)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: AppColors.accentWarm, borderRadius: BorderRadius.circular(20)),
                child: Text('Versão 1.0.0 — Build 2026.03.22',
                  style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.accent, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        _buildInfoCard('💌', 'O que é o OpenWhen',
          'O OpenWhen é uma plataforma digital de comunicação temporal e rede social emocional. Permite criar cartas digitais com data futura de abertura, combinando o valor sentimental de uma carta física com a viralidade de uma rede social moderna.'),
        const SizedBox(height: 12),
        _buildInfoCard('🔒', 'Segurança e Privacidade',
          'Desenvolvido em conformidade com a LGPD (Lei nº 13.709/2018) e o Marco Civil da Internet (Lei nº 12.965/2014). Seus dados são protegidos com criptografia de ponta e armazenados na infraestrutura Google Cloud Platform.'),
        const SizedBox(height: 12),
        _buildInfoCard('⚖️', 'Conformidade Legal',
          'O OpenWhen opera em total conformidade com a legislação brasileira vigente, incluindo LGPD, Marco Civil da Internet, Código de Defesa do Consumidor (Lei nº 8.078/1990) e demais normas aplicáveis ao setor de tecnologia.'),
        const SizedBox(height: 12),
        _buildInfoCard('🇧🇷', 'Empresa',
          'OpenWhen Tecnologia Ltda. — Empresa brasileira, com sede no Brasil. Foro de eleição: comarca de São Paulo/SP.'),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Contatos', style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.ink, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              _buildContact('Suporte geral', 'suporte@openwhen.app'),
              _buildContact('Privacidade e LGPD', 'privacidade@openwhen.app'),
              _buildContact('Jurídico', 'juridico@openwhen.app'),
              _buildContact('DPO', 'dpo@openwhen.app'),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: Text('© 2026 OpenWhen Tecnologia Ltda. Todos os direitos reservados.',
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.inkFaint, height: 1.5)),
        ),
      ],
    );
  }

  Widget _buildHelp() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.accentWarm,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.accent.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              const Text('💬', style: TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Central de Ajuda', style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.ink, fontWeight: FontWeight.w600)),
                    Text('Encontre respostas para as dúvidas mais frequentes.',
                      style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.inkSoft)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text('PERGUNTAS FREQUENTES',
          style: GoogleFonts.dmSans(fontSize: 10, color: AppColors.inkFaint, letterSpacing: 1.5, fontWeight: FontWeight.w500)),
        const SizedBox(height: 12),
        _buildFaq('Como enviar uma carta?',
          'Toque no botão ✏️ na tela principal. Preencha o título, selecione o estado emocional, escreva sua mensagem, informe o e-mail do destinatário e defina a data de abertura. A carta ficará bloqueada até a data escolhida.'),
        _buildFaq('O destinatário precisa ter conta no OpenWhen?',
          'Sim. Atualmente o destinatário precisa ter uma conta cadastrada no OpenWhen para receber cartas. O envio para e-mails externos estará disponível em breve.'),
        _buildFaq('Posso editar uma carta após o envio?',
          'Não. As cartas ficam seladas imediatamente após o envio para preservar a autenticidade e integridade da mensagem, em analogia às cartas físicas. Esta é uma decisão de produto intencional.'),
        _buildFaq('Como funciona o Feed Público?',
          'Ao abrir uma carta, você pode optar por publicá-la no Feed Público. Essa autorização é individual por carta. Cartas privadas jamais são exibidas publicamente sem sua autorização expressa.'),
        _buildFaq('Recebi uma carta de um desconhecido. O que fazer?',
          'Cartas de pessoas que você não segue ficam em "Pedidos de Carta" no Cofre. Você pode aceitar, recusar ou bloquear o remetente sem que ele saiba da sua decisão.'),
        _buildFaq('Como exportar minhas cartas?',
          'Acesse Configurações > Dados e Privacidade > Exportar minhas cartas. Você receberá um arquivo com todas as suas cartas abertas, conforme direito de portabilidade garantido pelo art. 18, inciso V, da LGPD.'),
        _buildFaq('Como deletar minha conta?',
          'Acesse Configurações > Dados e Privacidade > Deletar conta. A exclusão é irreversível e todos os seus dados serão permanentemente removidos em até 30 dias, conforme art. 18, inciso VI, da LGPD.'),
        _buildFaq('Encontrei um conteúdo ofensivo. Como denunciar?',
          'Toque nos três pontos ao lado de qualquer carta ou comentário e selecione "Denunciar". Nossa equipe analisará o conteúdo em até 24 horas. Denúncias graves são tratadas com prioridade.'),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Não encontrou o que procurava?',
                style: GoogleFonts.dmSerifDisplay(fontSize: 16, color: AppColors.ink, fontStyle: FontStyle.italic)),
              const SizedBox(height: 8),
              Text('Nossa equipe está disponível para ajudar:',
                style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.inkSoft)),
              const SizedBox(height: 12),
              _buildContact('Suporte geral', 'suporte@openwhen.app'),
              _buildContact('Tempo de resposta', 'até 2 dias úteis'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegalContent({
    required String lastUpdate,
    required String intro,
    required List<_Section> sections,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.accentWarm,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.accent.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, size: 16, color: AppColors.accent),
              const SizedBox(width: 8),
              Text('Última atualização: $lastUpdate',
                style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.accent, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(intro,
          style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.inkSoft, height: 1.7)),
        const SizedBox(height: 24),
        ...sections.map((s) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(s.title,
              style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.ink, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(s.content,
              style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.inkSoft, height: 1.7)),
            const SizedBox(height: 20),
          ],
        )),
      ],
    );
  }

  Widget _buildInfoCard(String emoji, String title, String content) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.ink, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(content, style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.inkSoft, height: 1.6)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaq(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question,
            style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.ink, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(answer,
            style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.inkSoft, height: 1.6)),
        ],
      ),
    );
  }

  Widget _buildContact(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text('$label: ', style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.inkSoft)),
          Text(value, style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.accent, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _Section {
  final String title;
  final String content;
  const _Section(this.title, this.content);
}
