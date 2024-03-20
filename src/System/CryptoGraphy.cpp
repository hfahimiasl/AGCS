#include "CryptoGraphy.h"


CryptoGraphy::CryptoGraphy():
	m_key(0),
	m_compressionMode(CompressionMode::CompressionModeAuto),
	m_protectionMode(ProtectionMode::ProtectionModeChecksum)
{
	qsrand(uint(QDateTime::currentMSecsSinceEpoch() & 0xFFFF));
}

CryptoGraphy::CryptoGraphy(const quint64 &key):
	m_key(key),
	m_compressionMode(CompressionMode::CompressionModeAuto),
	m_protectionMode(ProtectionMode::ProtectionModeChecksum)
{
	qsrand(uint(QDateTime::currentMSecsSinceEpoch() & 0xFFFF));
	splitKey();
}

void CryptoGraphy::setKey(const quint64 &key)
{
	m_key = key;
	splitKey();
}

bool CryptoGraphy::hasKey() const
{
	return !m_keyParts.isEmpty();
}

void CryptoGraphy::setCompressionMode(const CryptoGraphy::CompressionMode &mode)
{
	m_compressionMode = mode;
}

CryptoGraphy::CompressionMode CryptoGraphy::getCompressionMode() const
{
	return m_compressionMode;
}

void CryptoGraphy::setProtectionMode(const CryptoGraphy::ProtectionMode &mode)
{
	m_protectionMode = mode;
}

CryptoGraphy::ProtectionMode CryptoGraphy::getProtectionMode() const
{
	return m_protectionMode;
}

void CryptoGraphy::splitKey()
{
	m_keyParts.clear();
	m_keyParts.resize(8);

	for (int i = 0 ; i < 8 ; i++) {
		quint64 part = m_key;

		for (int j = i ; j > 0 ; j--) {
			part = part >> 8;
		}

		part = part & 0xff;
		m_keyParts[i] = static_cast<char>(part);
	}
}

QVariant CryptoGraphy::encrypt(const QVariant &cypher)
{
	if (m_keyParts.isEmpty()) {
		// qCritical() << "No key set";
		return QVariant::Invalid;
	}

	if (cypher == QVariant::Invalid) {
		// qCritical() << "Invalid input";
		return QVariant::Invalid;
	}

	QByteArray ba = cypher.toByteArray();

	CryptoFlags flags = CryptoFlag::CryptoFlagNone;

	if (m_compressionMode == CompressionMode::CompressionModeAlways) {
		ba = qCompress(ba, 9);
		flags |= CryptoFlag::CryptoFlagCompression;

	} else if (m_compressionMode == CompressionMode::CompressionModeAuto) {
		QByteArray compressed = qCompress(ba, 9);

		if (compressed.count() < ba.count()) {
			ba = compressed;
			flags |= CryptoFlag::CryptoFlagCompression;
		}
	}

	QByteArray integrityProtection {};

	if (m_protectionMode == ProtectionMode::ProtectionModeChecksum) {
		flags |= CryptoFlag::CryptoFlagChecksum;
		QDataStream s(&integrityProtection, QIODevice::WriteOnly);
		s << qChecksum(ba.constData(), ba.length());

	} else if (m_protectionMode == ProtectionMode::ProtectionModeHash) {
		flags |= CryptoFlag::CryptoFlagHash;
		QCryptographicHash hash(QCryptographicHash::Sha1);
		hash.addData(ba);
		integrityProtection += hash.result();
	}

	char randomChar = char(qrand() & 0xFF);
	ba = randomChar + integrityProtection + ba;

	int pos {0};
	char lastChar {0};

	int cnt = ba.count();

	while (pos < cnt) {
		ba[pos] = ba.at(pos) ^ m_keyParts.at(pos % 8) ^ lastChar;
		lastChar = ba.at(pos);
		++pos;
	}

	QByteArray resultArray {};
	resultArray.append(char(0x03));
	resultArray.append(char(flags));
	resultArray.append(ba);

	return QVariant::fromValue(resultArray);
}

QVariant CryptoGraphy::decrypt(const QVariant &cypher)
{
	if (m_keyParts.isEmpty()) {
		// qCritical() << "No key set";
		return QVariant::Invalid;
	}

	if (cypher == QVariant::Invalid) {
		// qCritical() << "Invalid input";
		return QVariant::Invalid;
	}

	QByteArray ba = cypher.toByteArray();

	if (ba.count() < 3) {
		return QVariant::Invalid;
	}

	char version = ba.at(0);

	if (version != 3) {
		// qCritical() << "Invalid version or not a cyphertext";
		return QVariant::Invalid;
	}

	CryptoFlags flags = CryptoFlags(ba.at(1));

	ba = ba.mid(2);

	int pos {0};
	int cnt {ba.count()};
	char lastChar {0};

	while (pos < cnt) {
		char currentChar = ba[pos];
		ba[pos] = ba.at(pos) ^ lastChar ^ m_keyParts.at(pos % 8);
		lastChar = currentChar;
		++pos;
	}

	ba = ba.mid(1);

	bool integrityOk {true};

	if (flags.testFlag(CryptoFlag::CryptoFlagChecksum)) {
		if (ba.length() < 2) {
			return QVariant::Invalid;
		}

		quint16 storedChecksum {};

		{
			QDataStream s(&ba, QIODevice::ReadOnly);
			s >> storedChecksum;
		}

		ba = ba.mid(2);
		quint16 checksum = qChecksum(ba.constData(), ba.length());
		integrityOk = (checksum == storedChecksum);

	} else if (flags.testFlag(CryptoFlag::CryptoFlagHash)) {
		if (ba.length() < 20) {
			return QVariant::Invalid;
		}

		QByteArray storedHash = ba.left(20);
		ba = ba.mid(20);
		QCryptographicHash hash(QCryptographicHash::Sha1);
		hash.addData(ba);
		integrityOk = (hash.result() == storedHash);
	}

	if (!integrityOk) {
		return QVariant::Invalid;
	}

	if (flags.testFlag(CryptoFlag::CryptoFlagCompression)) {
		ba = qUncompress(ba);
	}

	return QVariant::fromValue(ba);
}
